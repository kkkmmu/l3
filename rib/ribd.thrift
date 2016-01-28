namespace go ribd
typedef i32 int
struct NextHopInfo {
	1: int NextHopIfType,
    2: string NextHopIp,
    3: int NextHopIfIndex,
	4: int Metric,
}
struct Routes {
	1: string Ipaddr,
	2: string Mask,
	3: string NextHopIp,
	4: int NextHopIfType
	5: int IfIndex,
	6: int Metric,
	7: int Prototype,
	8: bool IsValid,
	9: int SliceIdx,
	10: int PolicyHitCounter,
	11: list<string>PolicyList
}
struct RoutesGetInfo {
	1: int StartIdx,
	2: int EndIdx,
	3: int Count,
	4: bool More,
	5: list<Routes> RouteList,
}
struct PolicyDefinitionSetsPrefix {
	1 : string	IpPrefix,
	2 : string 	MasklengthRange,
}
struct PolicyDefinitionSetsPrefixSet{
	1 : string 	PrefixSetName,
	2 : list<PolicyDefinitionSetsPrefix> 	IpPrefixList,
}
struct PolicyDefinitionSetsPrefixSetGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionSetsPrefixSet> PolicyDefinitionSetsPrefixSetList
}
struct PolicyDefinitionStmtMatchPrefixSetCondition{
	1 : string  Name
	2 : string 	PrefixSet
	3 : i32 	MatchSetOptions
}
struct PolicyDefinitionStmtMatchPrefixSetConditionsGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionStmtMatchPrefixSetCondition> PolicyDefinitionStmtMatchPrefixSetConditionList
}
//Neighbor 
//NeighborSet 
struct PolicyDefinitionStmtMatchNeighborSetCondition{
	1 : string  Name
	2 : string 	NeighborSet
	3 : i32 	MatchSetOptions
}
struct PolicyDefinitionStmtMatchNeighborSetConditionsGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionStmtMatchNeighborSetCondition> PolicyDefinitionStmtMatchNeighborSetConditionList
}
//Tag 
//TagSet
struct PolicyDefinitionStmtMatchTagSetCondition{
	1 : string  Name
	2 : string 	TagSet
	3 : i32 	MatchSetOptions
}
struct PolicyDefinitionStmtMatchTagSetConditionsGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionStmtMatchTagSetCondition> PolicyDefinitionStmtMatchTagSetConditionList
}

struct PolicyDefinitionStmtMatchProtocolCondition{
	1 : string  Name
	2 : string InstallProtocolEq
}
struct PolicyDefinitionStmtMatchProtocolConditionsGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionStmtMatchProtocolCondition> PolicyDefinitionStmtMatchProtocolConditionList
}

struct PolicyDefinitionStmtIgpActions{
	1 : string  Name
	2 : set<i32> 	SetTag
}
struct PolicyDefinitionStmtIgpActionsGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionStmtIgpActions> PolicyDefinitionStmtIgpActionsList
}

struct PolicyDefinitionStmtRouteDispositionAction{
	1 : string  Name
	2 : string 	RouteDisposition
}
struct PolicyDefinitionStmtRouteDispositionActionsGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionStmtRouteDispositionAction> PolicyDefinitionStmtRouteDispositionActionList
}

struct PolicyDefinitionStmtRedistributionAction{
	1 : string  Name
	2 : bool    Redistribute
	3 : string 	RedistributeTargetProtocol
}

struct PolicyDefinitionStmtRedistributionActionsGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionStmtRedistributionAction> PolicyDefinitionStmtRedistributionActionList
}

struct PolicyDefinitionStmtConfig{
	1:  string  Name
	2 : string 	AdminState
	3 : string 	MatchConditions
	4 : list<string> 	Conditions
	5 : list<string> 	Actions
	6 : bool     Export
	7 : bool     Import
}
struct PolicyDefinitionStmtState{
	1 : string  Name
	2 : string 	AdminState
	3 : string 	OperState
	4 : string 	MatchConditions
	5 : list<string> 	Conditions
	6 : list<string> 	Actions
	7 : bool     Export
	8 : bool     Import
	9 : int      HitCounter
	10: list<string> IpPrefixList
}
struct PolicyDefinitionStmtStateGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionStmtState> PolicyDefinitionStmtStateList
}
struct PolicyDefinitionConditionState{
	1 : string 	Name
	2 : string 	ConditionInfo
	3 : list<string> 	PolicyList
}
struct PolicyDefinitionConditionStateGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionConditionState> PolicyDefinitionConditionStateList
}
struct PolicyDefinitionActionState{
	1 : string 	Name
	2 : string 	ActionInfo
	3 : list<string> 	PolicyList
}
struct PolicyDefinitionActionStateGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinitionActionState> PolicyDefinitionActionStateList
}

struct PolicyDefinition{
	1: string Name
	2: list<string> PolicyDefinitionStatements
}
struct PolicyDefinitionGetInfo {
	1: int StartIdx
	2: int EndIdx
	3: int Count
	4: bool More
	5: list<PolicyDefinition> PolicyDefinitionList
}

//typedef RouteList  list<Routes>
service RouteService 
{
    int createV4Route (1:string destNetIp, 2:string networkMask, 3:int metric, 4:string nextHopIp, 5: int nextHopIfType, 6:int nextHopIfIndex, 7:int routeType);
    void updateV4Route (1:string destNetIp, 2:string networkMask, 3:int routeType, 4:string nextHopIp, 5:int nextHopIfIndex, 6:int metric);
    int deleteV4Route (1:string destNetIp, 2:string networkMask, 3:int routeType);
    NextHopInfo getRouteReachabilityInfo(1: string desIPv4MasktNet);
	list<Routes> getConnectedRoutesInfo();
    void printV4Routes();
	RoutesGetInfo getBulkRoutes(1: int fromIndex, 2: int count);
	Routes getRoute(1: string destNetIp, 2:string networkMask);
	void linkDown(1: int ifType, 2:int ifIndex);
	void linkUp(1: int ifType, 2:int ifIndex);
	void intfUp(1:string ipAddr);
	void intfDown(1:string ipAddr);

	bool CreatePolicyDefinitionSetsPrefixSet(1: PolicyDefinitionSetsPrefixSet config);
//	bool UpdatePolicyDefinitionSetsPrefixSet(1: PolicyDefinitionSetsPrefixSet origconfig, 2: PolicyDefinitionSetsPrefixSet newconfig, 3: list<bool> attrset);
//	bool DeletePolicyDefinitionSetsPrefixSet(1: PolicyDefinitionSetsPrefixSet config);

//	bool CreatePolicyDefinitionStmtMatchPrefixSetCondition(1: PolicyDefinitionStmtMatchPrefixSetCondition config);
//	bool UpdatePolicyDefinitionStmtMatchPrefixSetCondition(1: PolicyDefinitionStmtMatchPrefixSetCondition origconfig, 2: PolicyDefinitionStmtMatchPrefixSetCondition newconfig, 3: list<bool> attrset);
//	bool DeletePolicyDefinitionStmtMatchPrefixSetCondition(1: PolicyDefinitionStmtMatchPrefixSetCondition config);

//	bool CreatePolicyDefinitionStmtMatchNeighborSetCondition(1: PolicyDefinitionStmtMatchNeighborSetCondition config);
//	bool UpdatePolicyDefinitionStmtMatchNeighborSetCondition(1: PolicyDefinitionStmtMatchNeighborSetCondition origconfig, 2: PolicyDefinitionStmtMatchNeighborSetCondition newconfig, 3: list<bool> attrset);
//	bool DeletePolicyDefinitionStmtMatchNeighborSetCondition(1: PolicyDefinitionStmtMatchNeighborSetCondition config);

//	bool CreatePolicyDefinitionStmtMatchTagSetCondition(1: PolicyDefinitionStmtMatchTagSetCondition config);
//	bool UpdatePolicyDefinitionStmtMatchTagSetCondition(1: PolicyDefinitionStmtMatchTagSetCondition origconfig, 2: PolicyDefinitionStmtMatchTagSetCondition newconfig, 3: list<bool> attrset);
//	bool DeletePolicyDefinitionStmtMatchTagSetCondition(1: PolicyDefinitionStmtMatchTagSetCondition config);

	bool CreatePolicyDefinitionStmtMatchProtocolCondition(1: PolicyDefinitionStmtMatchProtocolCondition config);
//	bool UpdatePolicyDefinitionStmtMatchProtocolCondition(1: PolicyDefinitionStmtMatchProtocolCondition origconfig, 2: PolicyDefinitionStmtMatchProtocolCondition newconfig, 3: list<bool> attrset);
//	bool DeletePolicyDefinitionStmtMatchProtocolCondition(1: PolicyDefinitionStmtMatchProtocolCondition config);
//    PolicyDefinitionStmtMatchProtocolConditionsGetInfo getBulkPolicyDefinitionStmtMatchProtocolConditions(1: int fromIndex, 2: int count);

//	bool CreatePolicyDefinitionStmtIgpActions(1: PolicyDefinitionStmtIgpActions config);
//	bool UpdatePolicyDefinitionStmtIgpActions(1: PolicyDefinitionStmtIgpActions origconfig, 2: PolicyDefinitionStmtIgpActions newconfig, 3: list<bool> attrset);
//	bool DeletePolicyDefinitionStmtIgpActions(1: PolicyDefinitionStmtIgpActions config);

//	bool CreatePolicyDefinitionStmtRouteDispositionAction(1: PolicyDefinitionStmtRouteDispositionAction config);
//	bool UpdatePolicyDefinitionStmtRouteDispositionAction(1: PolicyDefinitionStmtRouteDispositionAction origconfig, 2: PolicyDefinitionStmtRouteDispositionAction newconfig, 3: list<bool> attrset);
//	bool DeletePolicyDefinitionStmtRouteDispositionAction(1: PolicyDefinitionStmtRouteDispositionAction config);

	bool CreatePolicyDefinitionStmtRedistributionAction(1: PolicyDefinitionStmtRedistributionAction config);
//	bool UpdatePolicyDefinitionStmtRedistributionAction(1: PolicyDefinitionStmtRedistributionAction origconfig, 2: PolicyDefinitionStmtRedistributionAction newconfig, 3: list<bool> attrset);
//	bool DeletePolicyDefinitionStmtRedistributionAction(1: PolicyDefinitionStmtRedistributionAction config);
//    PolicyDefinitionStmtRedistributionActionsGetInfo getBulkPolicyDefinitionStmtRedistributionActions(1: int fromIndex, 2: int count);

	bool CreatePolicyDefinitionStatement(1: PolicyDefinitionStmtConfig config);
//	bool UpdatePolicyDefinitionStatement(1: PolicyDefinitionStmtConfig origconfig, 2: PolicyDefinitionStmtConfig newconfig, 3: list<bool> attrset);
	bool DeletePolicyDefinitionStatement(1: PolicyDefinitionStmtConfig config);

	PolicyDefinitionStmtStateGetInfo GetBulkPolicyDefinitionStmtState(1: int fromIndex, 2: int count);
	PolicyDefinitionConditionStateGetInfo GetBulkPolicyDefinitionConditionState(1: int fromIndex, 2: int count);
	PolicyDefinitionActionStateGetInfo GetBulkPolicyDefinitionActionState(1: int fromIndex, 2: int count);

	bool CreatePolicyDefinition(1: PolicyDefinition config);
//	bool UpdatePolicyDefinition(1: PolicyDefinition origconfig, 2: PolicyDefinition newconfig, 3: list<bool> attrset);
//	bool DeletePolicyDefinition(1: PolicyDefinition config);
}
