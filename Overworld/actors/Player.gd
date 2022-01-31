extends "actor.gd"

var turn_timer = 0
var max_turn_delay = 0.05

func _ready():
	#update_look_direction(Directions.RIGHT)
	pass
	
func set_spawn(spawnPosition, direction):
	position = spawnPosition
	update_look_direction(direction)
	
func _physics_process(delta):
	if(curState == ActorState.IDLE ):
		if Input.is_action_just_pressed("ui_right"):
			update_look_direction(Directions.RIGHT)
		elif Input.is_action_just_pressed("ui_left"):
			update_look_direction(Directions.LEFT)
		elif Input.is_action_just_pressed("ui_down"):
			update_look_direction(Directions.DOWN)
		elif Input.is_action_just_pressed("ui_up"):
			update_look_direction(Directions.UP)	
		elif Input.is_action_pressed("ui_right"):
			turn_timer += delta
			if(turn_timer >= 0.05):
				move_input(Directions.RIGHT)
		elif Input.is_action_pressed("ui_left"):
			turn_timer += delta
			if(turn_timer >= 0.08):
				move_input(Directions.LEFT)
		elif Input.is_action_pressed("ui_down"):
			turn_timer += delta
			if(turn_timer >= 0.08):
				move_input(Directions.DOWN)
		elif Input.is_action_pressed("ui_up"):
			turn_timer += delta
			if(turn_timer >= 0.08):
				move_input(Directions.UP)

	if Input.is_action_just_released("ui_left"):
		 turn_timer = 0
	if Input.is_action_just_released("ui_down"):
		 turn_timer = 0
	if Input.is_action_just_released("ui_right"):
		 turn_timer = 0
	if Input.is_action_just_released("ui_up"):
		 turn_timer = 0

	if Input.is_action_just_pressed("ui_accept"):
		interact_ahead()

func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)

func interact_ahead():
	set_physics_process(false)
	var target = Map.look_ahead(self, facingDir)
	if target:
		if target.has_method("interact"):
			target.interact(facingDir)
		else:
			print("This target has no interact method")
	yield(get_tree().create_timer(0.1), "timeout")	
	set_physics_process(true)
