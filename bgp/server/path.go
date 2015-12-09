// path.go
package server

import (
	"fmt"
	"l3/bgp/packet"
	"log/syslog"
	"net"
	"ribd"
)

const (
	RouteTypeConnected uint8 = 1 << iota
	RouteTypeStatic
	RouteTypeIGP
	RouteTypeEGP
	RouteTypeMax
)

const RouteLocal = (RouteTypeConnected | RouteTypeStatic | RouteTypeIGP)

type Path struct {
	server *BGPServer
	logger *syslog.Writer
	peer *Peer
	pathAttrs []packet.BGPPathAttr
	withdrawn bool
	updated bool
	Pref uint32
	NextHop string
	NextHopIfType ribd.Int
	NextHopIfIdx ribd.Int
	Metric ribd.Int
	routeType uint8
}

func NewPath(server *BGPServer, peer *Peer, pa []packet.BGPPathAttr, withdrawn bool, updated bool, routeType uint8) *Path {
	path := &Path{
		server: server,
		logger: server.logger,
		peer: peer,
		pathAttrs: pa,
		withdrawn: withdrawn,
		updated: updated,
		routeType: routeType,
	}

	path.Pref = path.calculatePref()
	return path
}

func (p *Path) Clone() *Path {
	path := &Path{
		server: p.server,
		logger: p.server.logger,
		peer: p.peer,
		pathAttrs: p.pathAttrs,
		withdrawn: p.withdrawn,
		updated: p.updated,
		Pref: p.Pref,
		NextHop: p.NextHop,
		NextHopIfIdx: p.NextHopIfIdx,
		Metric: p.Metric,
		routeType: p.routeType,
	}

	return path
}

func (p *Path) calculatePref() uint32 {
	var pref uint32
	if p.IsLocal() {
		pref = BGP_INTERNAL_PREF
	} else if p.peer.IsInternal() {
		pref = BGP_INTERNAL_PREF
		for _, attr := range p.pathAttrs {
			if attr.GetCode() == packet.BGPPathAttrTypeLocalPref {
				pref = attr.(*packet.BGPPathAttrLocalPref).Value
				break
			}
		}
	} else {
		pref = BGP_EXTERNAL_PREF
	}

	return pref
}

func (p *Path) SetWithdrawn(status bool) {
	p.withdrawn = status
}

func (p *Path) IsWithdrawn() bool {
	return p.withdrawn
}

func (p *Path) UpdatePath(pa []packet.BGPPathAttr) {
	p.pathAttrs = pa
	p.Pref = p.calculatePref()
	p.updated = true
}

func (p *Path) SetUpdate(status bool) {
	p.updated = status
}

func (p *Path) IsUpdated() bool {
	return p.updated
}

func (p *Path) GetPreference() uint32 {
	return p.Pref
}

func (p *Path) IsLocal() bool {
	return (p.routeType & RouteLocal) != 0
}

func (p *Path) GetNumASes() uint32 {
	var total uint32 = 0
	for _, attr := range p.pathAttrs {
		if attr.GetCode() == packet.BGPPathAttrTypeASPath {
			asPaths := attr.(*packet.BGPPathAttrASPath).Value
			for _, asPath := range asPaths {
				if asPath.Type == packet.BGPASPathSet {
					total += 1
				} else if asPath.Type == packet.BGPASPathSequence {
					total += uint32(asPath.Length)
				}
			}
		}
	}

	return total
}

func (p *Path) GetOrigin() uint8 {
	for _, attr := range p.pathAttrs {
		if attr.GetCode() == packet.BGPPathAttrTypeOrigin {
			return uint8(attr.(*packet.BGPPathAttrOrigin).Value)
		}
	}

	return uint8(packet.BGPPathAttrOriginMax)
}

func (p *Path) GetNextHop() net.IP {
	for _, attr := range p.pathAttrs {
		if attr.GetCode() == packet.BGPPathAttrTypeNextHop {
			return attr.(*packet.BGPPathAttrNextHop).Value
		}
	}

	return net.IPv4zero
}

func (p *Path) GetReachabilityInfo() {
	ipStr := p.GetNextHop().String()
	reachabilityInfo, err := p.server.ribdClient.GetRouteReachabilityInfo(ipStr)
	if err != nil {
		p.logger.Info(fmt.Sprintf("NEXT_HOP[%s] is not reachable", ipStr))
		p.NextHop = ""
		return
	}
	p.NextHop = reachabilityInfo.NextHopIp
	if p.NextHop == "" || p.NextHop[0] == '0' {
		p.logger.Info(fmt.Sprintf("Next hop for %s is %s. Using %s as the next hop", ipStr, p.NextHop, ipStr))
		p.NextHop = ipStr
	}
	p.NextHopIfType = reachabilityInfo.NextHopIfType
	p.NextHopIfIdx = reachabilityInfo.NextHopIfIndex
	p.Metric = reachabilityInfo.Metric
}

func (p *Path) IsReachable() bool {
	if p.NextHop != "" {
		return true
	}

	return false
}
