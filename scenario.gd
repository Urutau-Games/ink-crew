extends Node3D

@export var room_size: Vector2i = Vector2i(30, 20)
@export var tile_size: int = 1
@export var floor_tile_scene: PackedScene

func _ready() -> void:
	var half_depth: int = room_size.y / 2
	var half_width: int = room_size.x / 2
	
	for x in range(-half_width, half_width):
		for y in range(-half_depth, half_depth):
			var tile = floor_tile_scene.instantiate()
			add_child(tile)
			tile.global_position = Vector3(x, 0, y)
