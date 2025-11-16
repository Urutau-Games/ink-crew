extends CanvasLayer
class_name Splats

@export var max_splats: int = 3
@export var splat_scene: PackedScene
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

func splat(color: Color):
	for i in max_splats:
		var sprite = splat_scene.instantiate()
		sprite.color = color
		sub_viewport.add_child(sprite)
		await get_tree().create_timer(0.1).timeout
