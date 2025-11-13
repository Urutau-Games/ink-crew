extends InputController
class_name RandomNpcController

@export var bomb_time: float = 2.5
@export var min_walk_time: float = .5
@export var max_walk_time: float = 2

var _bomb_timer: Timer
var _walk_timer: Timer

var _drop_bomb: bool = false
var _current_direction: Vector2

func _ready() -> void:
	_randomize_direction()
	_start_walk_timer()
	_start_bomb_timer()

func _randomize_direction():
	_current_direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))

func _start_walk_timer():
	_walk_timer = Timer.new()
	_walk_timer.timeout.connect(_on_walk_timer_timeout)
	_walk_timer.one_shot = false
	add_child(_walk_timer)
	_walk_timer.start(randf_range(min_walk_time, max_walk_time))

func _start_bomb_timer():
	_bomb_timer = Timer.new()
	_bomb_timer.timeout.connect(_on_bomb_timer_timeout)
	_bomb_timer.one_shot = false
	add_child(_bomb_timer)
	_bomb_timer.start(bomb_time)

func _on_bomb_timer_timeout():
	_drop_bomb = true

func _on_walk_timer_timeout():
	_randomize_direction()

func get_input() -> InputPackage:
	var input := InputPackage.new()
	input.direction = _current_direction
	input.bomb_dropped = _drop_bomb
	
	if(_drop_bomb):
		_drop_bomb = false
	
	return input
