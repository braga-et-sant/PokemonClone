extends Node2D

onready var Map = get_owner()

var facingDir
enum ActorState { IDLE, TURNING, WALKING, BUMPING }
var curState = ActorState.IDLE

onready var sprite = $Sprite
onready var animPlayer = $AnimationPlayer
onready var tween = $Tween

func _ready():
	create_anims()

func create_anims():
	##Walk Down
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	
	animation.set_length(0.15)

	animation.track_set_path(track_index, "Sprite:frame")
	animation.track_insert_key(track_index, 0, 11)
	animation.track_insert_key(track_index, 0.5, 5)
	animation.track_insert_key(track_index, 0.10, 8)
	animation.value_track_set_update_mode(track_index, 1)
	
	animPlayer.add_animation("walkDown", animation)
	
	##Walk Left
	animation = Animation.new()
	track_index = animation.add_track(Animation.TYPE_VALUE)
	
	animation.set_length(0.15)
	animation.track_set_path(track_index, "Sprite:frame")
	animation.track_insert_key(track_index, 0, 9)
	animation.track_insert_key(track_index, 0.5, 6)
	animation.track_insert_key(track_index, 0.10, 3)
	animation.value_track_set_update_mode(track_index, 1)
	
	animPlayer.add_animation("walkLeft", animation)
	
	##Walk Right
	animation = Animation.new()
	track_index = animation.add_track(Animation.TYPE_VALUE)
	
	animation.set_length(0.15)
	animation.track_set_path(track_index, "Sprite:frame")
	animation.track_insert_key(track_index, 0, 4)
	animation.track_insert_key(track_index, 0.5, 1)
	animation.track_insert_key(track_index, 0.10, 7)
	animation.value_track_set_update_mode(track_index, 1)
	
	animPlayer.add_animation("walkRight", animation)
	
	##Walk Up
	animation = Animation.new()
	track_index = animation.add_track(Animation.TYPE_VALUE)
	
	animation.set_length(0.15)
	animation.track_set_path(track_index, "Sprite:frame")
	animation.track_insert_key(track_index, 0, 10)
	animation.track_insert_key(track_index, 0.5, 0)
	animation.track_insert_key(track_index, 0.10, 2)
	animation.value_track_set_update_mode(track_index, 1)
	
	animPlayer.add_animation("walkUp", animation)
	
	##Idle Down
	animation = Animation.new()
	track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.set_length(0.1)
	animation.track_set_path(track_index, "Sprite:frame")
	animation.track_insert_key(track_index, 0, 5)
	
	animPlayer.add_animation("idleDown", animation)
	
	##Idle Left
	animation = Animation.new()
	track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.set_length(0.1)
	animation.track_set_path(track_index, "Sprite:frame")
	animation.track_insert_key(track_index, 0, 6)
	
	animPlayer.add_animation("idleLeft", animation)
	
	##Idle Right
	animation = Animation.new()
	track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.set_length(0.1)
	animation.track_set_path(track_index, "Sprite:frame")
	animation.track_insert_key(track_index, 0, 1)
	
	animPlayer.add_animation("idleRight", animation)
	
	##Idle Up
	animation = Animation.new()
	track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.set_length(0.1)
	animation.track_set_path(track_index, "Sprite:frame")
	animation.track_insert_key(track_index, 0, 0)
	
	animPlayer.add_animation("idleUp", animation)

func move_input(input_direction):
	update_look_direction(input_direction)
	var target_position = Map.request_move(self, input_direction)
	if target_position:
		move_to(target_position)
	else:
		bump()

func update_look_direction(direction):
	if animPlayer:
		match direction:
			Directions.UP:
				animPlayer.play("idleUp")
			Directions.LEFT:
				animPlayer.play("idleLeft")
			Directions.DOWN:
				animPlayer.play("idleDown")
			Directions.RIGHT:
				animPlayer.play("idleRight")
	else:
		sprite.rotation = direction.angle()
	facingDir = direction

func move_to(target_position):
	set_process(false)
	curState = ActorState.WALKING
	match facingDir:
		Directions.UP:
			animPlayer.play("walkUp")
		Directions.LEFT:
			animPlayer.play("walkLeft")
		Directions.DOWN:
			animPlayer.play("walkDown")
		Directions.RIGHT:
			animPlayer.play("walkRight")
		
	tween.interpolate_property(
		self,"position",
		position ,target_position,
		animPlayer.current_animation_length,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

	# Stop the function execution until the animation finished
	yield(animPlayer, "animation_finished")
	yield(tween, "tween_all_completed")
	update_look_direction(facingDir)
	set_process(true)
	curState = ActorState.IDLE

func bump():
	curState = ActorState.BUMPING
	set_process(false)
	update_look_direction(facingDir)
	animPlayer.play("bump")
	yield(animPlayer, "animation_finished")
	yield(get_tree().create_timer(0.2), "timeout")
	set_process(true)
	print("oi m8 ima bump")
	curState = ActorState.IDLE
