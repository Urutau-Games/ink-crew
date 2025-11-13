extends InputController
class_name HumanPlayerController

func get_input() -> InputPackage:
	var input := InputPackage.new()
	
	input.bomb_dropped = Input.is_action_just_pressed("drop_bomb")
	input.direction = Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward")
	
	return input
