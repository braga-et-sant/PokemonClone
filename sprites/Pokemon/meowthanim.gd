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
	
	setup(flag)
	
	animloop()
	
func setup(flag : int):
	animtype = "back" if (flag == 0) else "front"
	var other = "Back" if (flag == 1) else "Front"
	get_node(other).queue_free()
	
	var animIdle = $AnimationPlayer.get_animation("idle" + animtype)
	var animRare = $AnimationPlayer.get_animation("rare" + animtype)
	
	var index = animIdle.add_track(Animation.TYPE_METHOD)
	animIdle.track_set_path(index, ".")
	animIdle.track_insert_key(index, animIdle.length, {"method" : "animloop" , "args" : []} )
	
	var index2 = animRare.add_track(Animation.TYPE_METHOD)
	animRare.track_set_path(index2, ".")
	animRare.track_insert_key(index2, animRare.length, {"method" : "animloop" , "args" : []} )
	
	

func animloop():
	if(count == limit):
		count = 0
		$AnimationPlayer.play("rare" + animtype)
	else:
		count +=1
		$AnimationPlayer.play("idle" + animtype)
