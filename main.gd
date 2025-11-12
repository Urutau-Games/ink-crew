extends Node3D

func _unhandled_input(event: InputEvent) -> void:
	var keyboard = event as InputEventKey
	if keyboard and keyboard.keycode == KEY_F3:
		get_tree().reload_current_scene()
