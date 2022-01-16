extends Node
class_name MoveDataBase

const filepathMoveData = "res://Data/MoveData/"
const filepathMove = "res://Data/MoveData/MoveNode/Move.gd"

static func get_move_by_name(name):
	name = name if !(name == null) else ""
	var file_name = filepathMoveData + name.replace(" ", "_") + ".gd"
	var dataUnloaded = load(file_name)

	if dataUnloaded == null:
		file_name = filepathMoveData + name + ".gd"
		dataUnloaded = load(file_name)

	if dataUnloaded == null:
		print("MoveDatabase ERROR: The move, '" + name + "' does not have a file. Loading default move")
		file_name = filepathMoveData + "Ice_Beam.gd"
	
	var data = load(file_name).new()

	var move = load(filepathMove).new()
	
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
	pass
	
