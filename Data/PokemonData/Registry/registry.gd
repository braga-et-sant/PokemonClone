extends Object
class_name registry
const pokemon = {
	1: "Meowth",
	2: "Celebi",
	3: "Quilava",
	4: "Farfetchd",
	5: "Charmander"
}
static func get_pokemon_class(id):
	#("res://data/Pokemon" + pokemon[id] + ".gd")
	return load("res://data/PokemonData/" + pokemon[id] + ".gd").new()
