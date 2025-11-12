extends Node3D
class_name FloorTile

@onready var tile: CSGBox3D = $Tile

@export var textures: Dictionary[Constants.FloorColor, Texture2D] = {}
@export var empty_color: Constants.FloorColor = Constants.FloorColor.Light

var _material: StandardMaterial3D

func _ready() -> void:
	_material = tile.material
	_material.albedo_texture = textures[empty_color]

func paint(color: Constants.FloorColor):
	_material.albedo_texture = textures[color]
