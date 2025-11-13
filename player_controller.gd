@abstract 
class_name InputController
extends Node

@abstract 
func get_input() -> InputPackage

class InputPackage:
	var direction: Vector2
	var bomb_dropped: bool
