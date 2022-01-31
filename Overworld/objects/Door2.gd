extends Sprite

func interact(_facingDir):
	print("Hi")
	Utils.get_scene_manager().transition_to_scene("res://Overworld/maps/house1.tscn", Vector2(114, 240), Directions.UP)
