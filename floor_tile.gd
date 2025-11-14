extends Node3D
class_name FloorTile

@onready var tile: CSGBox3D = $Tile

@export var textures: Dictionary[Constants.FloorColor, Texture2D] = {}
@export var empty_color: Constants.FloorColor = Constants.FloorColor.Light

var _material: StandardMaterial3D
var _current_owner: Constants.PlayerTag = Constants.PlayerTag.None

func _ready() -> void:
	_material = tile.material
	_material.albedo_texture = textures[empty_color]

func paint(color: Constants.FloorColor, new_owner: Constants.PlayerTag):
	_material.albedo_texture = textures[color]
	var previous_owner = _current_owner
	_current_owner = new_owner
	
	EventBus.tile_painted.emit(_current_owner, previous_owner)
