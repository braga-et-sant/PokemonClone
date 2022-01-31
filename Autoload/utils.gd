extends Node

func get_player():
	return get_node("/root/SceneManager/CurrentScene").get_children().back().find_node("Player")

func get_scene_manager():
	print(self.get_script().get_path().get_base_dir())
	return get_node("/root/SceneManager")
