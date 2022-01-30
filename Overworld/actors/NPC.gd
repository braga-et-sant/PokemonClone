extends "actor.gd"


##This thing's offset has to be 5 for default for some reason???

func _ready():
	update_look_direction(Directions.RIGHT)
	position = Vector2(336, 336)
	var timer = Timer.new()
	add_child(timer)

	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(0.5)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()
	
func _on_Timer_timeout():
	randomize()
	var move = randi()%5
	var direction = null
	match move:
		0, 1, 2, 3:
			#direction = Directions.RIGHT
			pass
		4:
			#direction = Directions.LEFT
			pass
	if !direction:
		return
	update_look_direction(direction)
	var target_position = Map.request_move(self, direction)
	if target_position:
		move_to(target_position)
	else:
		bump()

func interact(dir):
	print("Hello it is I, the NPC")
	update_look_direction(dir * -1)

