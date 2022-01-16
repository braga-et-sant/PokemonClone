extends Node2D


var count
var limit = 6
var flag

var animtype

func _ready():
	#0 back, 1 front
	count = 0
	if flag == null:
		print("No base sprite set, loading back")
		flag = 0
	
	setup()
	
	animloop()
	
func setup():
	animtype = "back" if (flag == 0) else "front"
	var other = "Back" if (flag == 1) else "Front"
	get_node(other).queue_free()
	
	var animIdle = $AnimationPlayer.get_animation("idle" + animtype)
	
	var index = animIdle.add_track(Animation.TYPE_METHOD)
	animIdle.track_set_path(index, ".")
	animIdle.track_insert_key(index, animIdle.length, {"method" : "animloop" , "args" : []} )
	

func animloop():
	$AnimationPlayer.play("idle" + animtype)
