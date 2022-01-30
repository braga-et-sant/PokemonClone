extends Control

enum MoveOption {M1, M2, M3, M4}

const MOVEARROWDEFAULT = Vector2(-14, 8)

onready var arrow = $MoveSelect/ArrowSelect

func _ready():
	arrow.rect_position = MOVEARROWDEFAULT

func setup(pokePlayer : pokemon_instance):
	$MoveSelect/MoveBox/Move1.text = pokePlayer.moves[0].name
	$MoveSelect/MoveBox/Move2.text = pokePlayer.moves[1].name
	$MoveSelect/MoveBox/Move3.text = pokePlayer.moves[2].name
	$MoveSelect/MoveBox/Move4.text = pokePlayer.moves[3].name

func changeArrowPos(index : int, move : Move) -> void:
	match index:
		MoveOption.M1:
			arrow.rect_position = Vector2(-14, 8)
		MoveOption.M2:
			arrow.rect_position = Vector2(64, 8)
		MoveOption.M3:
			arrow.rect_position = Vector2(-14, 31)
		MoveOption.M4:
			arrow.rect_position = Vector2(64, 31)
	$MoveInfo/MovePP/PPInfo.text = str(move.total_pp) + "/" + str(move.total_pp)
	$MoveInfo/MoveType/TypeInfo.text = TypeStr.new().toStr(move.type)
