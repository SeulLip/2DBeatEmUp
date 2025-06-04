extends Node


func hit_stop_light():
	Engine.time_scale = 0
	await get_tree().create_timer(0.12, true, false, true).timeout
	Engine.time_scale = 1


func hit_stop_medium():
	Engine.time_scale = 0
	await get_tree().create_timer(0.20, true, false, true).timeout
	Engine.time_scale = 1
