extends Control

const CHAR_READ_RATE = 0.01

onready var textbox_container = $BattleTextBox
onready var start_symbol = $BattleTextBox/MarginContainer/TextBox/Start
onready var end_symbol = $BattleTextBox/MarginContainer/TextBox/End
onready var label = $BattleTextBox/MarginContainer/TextBox/BattleLog

signal allPrinted

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	hide_textbox()

func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_cancel"):
				label.percent_visible = 1.0
				$Tween.remove_all()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_cancel"):
				close_dialog()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.percent_visible = 0.0
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			pass#print("Changing state to: State.READY")
		State.READING:
			pass#print("Changing state to: State.READING")
		State.FINISHED:
			pass#print("Changing state to: State.FINISHED")

func _on_Tween_tween_completed(object, key):
	end_symbol.text = "v"
	change_state(State.FINISHED)
	$Timer.start(0.8)
	
func close_dialog():
	if text_queue.empty():
		#print("This was the last piece of text queued")
		emit_signal("allPrinted")
		
	change_state(State.READY)
	hide_textbox()

func _on_Timer_timeout():
	close_dialog()
