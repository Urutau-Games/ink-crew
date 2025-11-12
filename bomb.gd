extends Node3D
class_name Bomb

signal exploded()

@export var bomb_timer := 1.5
@export var bomb_strength := 1
@export var textures: Dictionary[Constants.FloorColor, Texture2D] = {}

@export var color: Constants.FloorColor = Constants.FloorColor.Green

var _affected_tiles: Array = []

@onready var visuals = $Visuals
@onready var _material: StandardMaterial3D

func _ready() -> void:
	_material = visuals.material
	_define_color()
	_adjust_raycasts()

func _adjust_raycasts():
	if %RayCasts:
		for raycast: RayCast3D in %RayCasts.get_children():
			raycast.target_position *= bomb_strength
			get_tree().create_timer(bomb_timer).timeout.connect(_explode)

func _define_color():
	if _material:
		_material.albedo_texture = textures[color]

func _explode():
	for raycast: RayCast3D in %RayCasts.get_children():
		raycast.force_raycast_update()
		while(raycast.is_colliding()):
			var collider = raycast.get_collider()
			var object = collider.get_parent()
			
			if not object is FloorTile:
				break
				
			_affected_tiles.push_back(collider.get_parent())
			raycast.add_exception(collider)
			raycast.force_raycast_update()
	
	for tile in _affected_tiles:
		tile.paint(color)
		
	exploded.emit()
	queue_free()
