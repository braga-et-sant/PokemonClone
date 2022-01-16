extends Control

enum SelectPokeOption {P1, P2, P3, P4, P5, P6}

onready var arrow = $BasePanel/Arrow

const SWITCHARROWDEFAULT = Vector2(37, 58)

func _ready():
	arrow.rect_position = SWITCHARROWDEFAULT

func setup(teamPlayer):
	var grid = $BasePanel/PartyContainer
	var count = 0
	for child in grid.get_children():
		if(count != teamPlayer.size() and teamPlayer[count] != null):
			child.text = teamPlayer[count].nick
			child.get_child(0).text = str(teamPlayer[count].chp) + "/" + str(teamPlayer[count].rawstats["hp"])
			count+=1
		else:
			child.text = "      -      "
			child.get_child(0).text = ""
			
func changeArrowPos(index : int ) -> void:
	match index:
		SelectPokeOption.P1:
			arrow.rect_position = Vector2(37, 58)
		SelectPokeOption.P2:
			arrow.rect_position = Vector2(120, 58)
		SelectPokeOption.P3:
			arrow.rect_position = Vector2(37, 88)
		SelectPokeOption.P4:
			arrow.rect_position = Vector2(120, 88)
		SelectPokeOption.P5:
			arrow.rect_position = Vector2(37, 118)
		SelectPokeOption.P6:
			arrow.rect_position = Vector2(120, 118)
