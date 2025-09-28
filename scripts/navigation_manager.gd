extends Node

const scene_introduction = preload("res://scenes/introduction.tscn")
const scene_root = preload("res://scenes/root.tscn")

var 	spawn_door_tag

func go_to_level(level_tag, destination_tag	):
	var scene_to_load 	
	match level_tag:
		"introduction":
			scene_to_load = scene_introduction
		"root":
			scene_to_load = scene_root
	print(level_tag)
	if scene_to_load != null:
		#TransitionScreen.transition()
		#await TransitionScreen.on_transition_finished
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)
		
			
