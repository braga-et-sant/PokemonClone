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
var type1
var type2
var level

var moves = {"move1": null, "move2": null, "move3":null, "move4":null}
var rawstats = {"hp":0, "atk":0, "def":0, "spd":0, "spa":0, "spe": 0}
var evs = {"hp":0, "atk":0, "def":0, "spd":0, "spa":0, "spe": 0}
var ivs = {"hp":0, "atk":0, "def":0, "spd":0, "spa":0, "spe": 0}


func _ready():
	pass # Replace with function body.
	
func default(poke_n):
	var regist = registry.new()
	var poke = regist.get_pokemon_class(1)
	ID = poke.ID
	OT = ""
	nick = poke.name
	ability = poke.ability
	rawstats = {"hp":poke.hp, "atk":poke.attack, "def":poke.defense, "spd":poke.sp_defense, "spa":poke.sp_attack, "spe": poke.speed}
	chp = rawstats["hp"]-1
	type1 = poke.type
	
	randomize()
	level = randi()%10+1
	
	var moved = MoveDataBase.new()
	var m1 = moved.get_move_by_name("Ice Beam")
	var m2 = moved.get_move_by_name("Ember")
	var m3 = moved.get_move_by_name("Hydro Pump")
	var m4 = null
	moves = {"move1": m1, "move2": m2, "move3":m3, "move4":null}
	
	return self

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
