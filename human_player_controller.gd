extends InputController
class_name HumanPlayerController

func get_input() -> InputPackage:
	var new_input := InputPackage.new()
	
	new_input.bomb_dropped = Input.is_action_just_pressed("drop_bomb")
	new_input.direction = Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward")
	
	return new_input
