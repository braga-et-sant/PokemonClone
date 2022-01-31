extends Sprite

func interact(_facingDir):
	print("Hi")
	Utils.get_scene_manager().transition_to_scene("res://Overworld/maps/map1test2.tscn", Vector2(432, 528), Directions.DOWN)
