extends Sprite2D
class_name Splat

@export var splat_textures: Array[Texture2D]
@export var color: Color
@export var splat_show_time: float = 0.1
@export var splat_decay_time: float = 0.4
@export var min_x: float = 50
@export var max_x: float = 1100
@export var min_y: float = 50
@export var max_y: float = 600

func _ready() -> void:
	visible = false
	texture = splat_textures.pick_random()
	modulate = Color(color, 0)
	global_position = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
	visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", .75, splat_show_time)
	tween.tween_property(self, "modulate:a", 0, splat_decay_time)
	tween.parallel().tween_property(self, "global_position:y", 1800, splat_decay_time)
	tween.tween_callback(queue_free)
