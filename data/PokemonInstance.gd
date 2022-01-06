extends Object
class_name pokemon_instance

var ID
var OT
var nick
var ability
var nature
var metat
var gender
var held
var totexp
var chp
var status

var moves = {"move1": null, "move2": null, "move3":null, "move4":null}
var rawstats = {"hp":0, "atk":0, "def":0, "spd":0, "spa":0, "spe": 0}
var evs = {"hp":0, "atk":0, "def":0, "spd":0, "spa":0, "spe": 0}
var ivs = {"hp":0, "atk":0, "def":0, "spd":0, "spa":0, "spe": 0}


func _ready():
	pass # Replace with function body.
	

func _to_string():
	var p1 =  "" + str(ID) + "|" + OT + "|" + nick + "|" + ability + "|" + nature  + "|" + held  + "|" \
	 + metat  + "|" + gender + "|" + str(totexp)  + "|" + str(chp)  + "|" + status  + "|" + "\nMoves:\n"
	var p2 = str(moves)
	var p3 = str(rawstats)
	var p4 = str(evs)
	var p5 = str(ivs)
	return p1 + p2 + "\nRawStats\n" + p3 + "\nEVs\n" + p4 + "\nIVs\n" + p5


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
