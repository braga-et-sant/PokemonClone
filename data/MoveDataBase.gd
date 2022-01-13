extends Node
class_name MoveDataBase

static func get_move_by_name(name):
	name = name if !(name == null) else ""
	var file_name = "res://data/moves/" + name.replace(" ", "_") + ".gd"
	var data = load(file_name)

	if data == null:
		file_name = "res://data/moves/" + name + ".gd"
		data = load(file_name)
	
	if data == null:
		print("MoveDatabase ERROR: The move, '" + name + "' does not have a file. Loading default move")
		file_name = "res://data/moves/Ice_Beam.gd"
	
	data = load(file_name).new()

	var move = load("res://data/moves/Move.gd").new()
	
	move.name = data.name
	move.type = data.type
	move.style = data.style
	move.base_power = data.base_power
	move.accuracy = data.accuracy
	move.priority = data.priority
	move.critical_hit_level = data.critical_hit_level
	move.secondary_effect_chance = data.secondary_effect_chance
	move.flags = data.flags
	move.total_pp = data.total_pp
	move.target_ability = data.target_ability
	move.main_status_effect = data.main_status_effect
	move.remaining_pp = move.total_pp
	return move
	
func _ready():
	var move = get_move_by_name("Ember")
	print(move.name)
	print(move.type)
	var move2 = get_move_by_name("Ice Beam")
	print(move2.name)
	print(move2.type)
	
