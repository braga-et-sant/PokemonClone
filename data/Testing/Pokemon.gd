extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var types = Type.new()
	var regist = registry.new()
	var instance = pokemon_instance.new()
	var bug = types.BUG
	var quilava = regist.get_pokemon_class(1)
	print(quilava.name)
	print(quilava.type1)
	print(quilava.ID)

	var newinstance = genFromRegistry(2)
	print(newinstance)
	
	var newinstance2 = genFromRegistry(3)
	print(newinstance2)
	
 
	
	
func genFromRegistry(ID):
	var regist = registry.new()
	var poke = regist.get_pokemon_class(ID)
	var instance = pokemon_instance.new()
	instance.ID = poke.ID
	instance.OT = "Debug trainer"
	instance.nick = poke.name
	instance.ability = poke.ability
	instance.nature = "debug nature"
	instance.held = "debug item"
	instance.metat = "debug place"
	instance.gender = "Male"
	instance.totexp = 2000
	instance.chp = 20
	instance.status = "None"
	instance.moves["move1"] = "Move 1" 
	instance.moves["move2"] = "Move 2"
	instance.moves["move3"] = "Move 3"
	instance.moves["move4"] = "Move 4"
	instance.rawstats["hp"] = 50 
	instance.rawstats["atk"] = 31
	instance.rawstats["def"] = 32
	instance.rawstats["spd"] = 33
	instance.rawstats["spa"] = 34
	instance.rawstats["spe"] = 35
	return instance
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
