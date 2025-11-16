@abstract 
class_name InputController
extends Node

var input: InputPackage

func _init() -> void:
	input = InputPackage.new()

func _process(_delta: float) -> void:
	input = get_input()

@abstract 
func get_input() -> InputPackage

class InputPackage:
	var direction: Vector2 = Vector2.ZERO
	var bomb_dropped: bool = false
