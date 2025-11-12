extends Node3D

signal exploded()

@export var bomb_timer := 1.5
@export var bomb_strength := 1
@export var color: Constants.FloorColor = Constants.FloorColor.Green

var _affected_tiles: Array = []

func _ready() -> void:
	for raycast: RayCast3D in %RayCasts.get_children():
		raycast.target_position *= bomb_strength
		get_tree().create_timer(bomb_timer).timeout.connect(_explode)

func _explode():
	for raycast: RayCast3D in %RayCasts.get_children():
		raycast.force_raycast_update()
		while(raycast.is_colliding()):
			var affected_tile = raycast.get_collider()
			_affected_tiles.push_back(affected_tile)
			raycast.add_exception(affected_tile)
			raycast.force_raycast_update()
	
	for tile in _affected_tiles:
		tile.get_parent().paint(color)
		
	exploded.emit()
	queue_free()
