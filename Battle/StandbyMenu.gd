extends Control

const ARROWDEFAULT = Vector2(-5, 1)
const ARROWSPACING = 13
const STANDBYOPTIONS = 4

onready var arrow = $SelectAction/ArrowSelect

func _ready():
	arrow.rect_position = ARROWDEFAULT

func changePrompt(prompt : String):
	$StandbyPromptPanel/StandbyPrompt.text = prompt

func changeArrowPos(index : int ) -> void:
	arrow.rect_position.y =  ARROWDEFAULT.y + (index % STANDBYOPTIONS) * ARROWSPACING
