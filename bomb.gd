extends Node3D

signal exploded()

@export var bomb_timer := 1.5
@export var bomb_strength := 1

func _ready() -> void:
	for raycast: RayCast3D in %RayCasts.get_children():
		raycast.target_position *= bomb_strength
		get_tree().create_timer(bomb_timer).timeout.connect(_explode)

func _explode():
	for raycast: RayCast3D in %RayCasts.get_children():
		raycast.enabled = true
		
	exploded.emit()
	queue_free()
