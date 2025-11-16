extends Node3D
class_name FloorTile

@onready var tile: CSGBox3D = $Tile

@export var textures: Dictionary[Constants.FloorColor, Texture2D] = {}
@export var empty_color: Constants.FloorColor = Constants.FloorColor.Light
@export var splat_textures: Array[Texture2D]

var _material: StandardMaterial3D
var _material_overlay: StandardMaterial3D

var _current_owner: Constants.PlayerTag = Constants.PlayerTag.None

func _ready() -> void:
	_material = tile.material
	_material_overlay = tile.material_overlay
	_material.albedo_texture = textures[empty_color]

func paint(color: Constants.FloorColor, new_owner: Constants.PlayerTag):
	_material_overlay.albedo_texture = splat_textures.pick_random()
	_material_overlay.albedo_color = Constants.colors[color]
	
	var previous_owner = _current_owner
	
	_current_owner = new_owner
	
	EventBus.tile_painted.emit(_current_owner, previous_owner)
