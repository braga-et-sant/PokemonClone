extends Object

class_name action

enum ActionType {MOVE, SWITCH}

var move
var actor
var target
var actionType
var priority

func _init(_actionType, _move, _actor, _target, _priority):
	self.actionType = _actionType
	self.move = _move
	self.actor = _actor
	self.target = _target
	self.priority = _priority

static func sortPriority(a, b):
	return a.priority > b.priority
	
static func sortSpeed(a, b):
	if(a.actor.rawstats["spe"] == b.actor.rawstats["spe"]):
		randomize()
		return (randi()%2 == 0)
	return a.actor.rawstats["spe"] > b.actor.rawstats["spe"]
	
func _to_string():
	if(move != null):
		return "Action Type (0 = Move, 1 = Switch) :" + str(actionType) + " Move:" + move.name +  \
		" Actor: " + actor.nick + " Priority: " + str(priority) + " Speed: " + str(actor.rawstats["spe"])
	else:
		return "Action Type (0 = Move, 1 = Switch) :" + str(actionType) + " Actor: " + actor.nick + \
		" Priority: " + str(priority) + " Speed: " + str(actor.rawstats["spe"])
