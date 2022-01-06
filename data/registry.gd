extends Object
class_name registry
const pokemon = {
	1: "Meowth",
	2: "Celebi",
	3: "Quilava",
}
static func get_pokemon_class(id):
	#print("res://data/Pokemon" + pokemon[id] + ".gd")
	return load("res://data/Pokemon" + pokemon[id] + ".gd").new()
