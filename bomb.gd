extends Node3D

signal exploded()

@export var bomb_timer := 1.5


func _ready() -> void:
	get_tree().create_timer(bomb_timer).timeout.connect(_explode)

func _explode():
	exploded.emit()
	queue_free()
