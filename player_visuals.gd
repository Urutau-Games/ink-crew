extends Node3D

@export var textures: Dictionary[Constants.FloorColor, Texture2D] = {}
@onready var cilinder: CSGCylinder3D = $Cilinder

func set_color(color: Constants.FloorColor):
	cilinder.material.albedo_texture = textures[color]
