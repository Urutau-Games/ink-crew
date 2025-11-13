extends CharacterBody3D

var _rotation_acceleration: float = 10
var _grounded_desacceleration: float = 0
var _speed: float = 5
var _mass: float = 15

@onready var visuals: Node3D = %Visuals

@export_category("Scene Settings")
@export var bomb_scene: PackedScene
@export var input_controler: InputController

@export_category("Gameplay")
@export var max_bombs: int = 1
@export var bomb_color: Constants.FloorColor = Constants.FloorColor.Green

var _available_bombs: int

func _ready() -> void:
	_available_bombs = max_bombs
	%Visuals.set_color(bomb_color)

func _process(_delta: float) -> void:
	if(input_controler.input.bomb_dropped and _available_bombs > 0):
		_drop_bomb()
		_available_bombs -= 1

func _physics_process(delta: float) -> void:
	var direction = input_controler.input.direction.normalized()
	
	_rotate_visuals(direction, delta)
	_apply_movement(direction, delta)

func _drop_bomb():
	var bomb: Bomb = bomb_scene.instantiate()
	bomb.color = bomb_color
	add_child(bomb)
	bomb.global_position = Vector3(roundi(global_position.x), 0.6, roundi(global_position.z))
	bomb.exploded.connect(_refill_bombs)

func _refill_bombs():
	_available_bombs = min(_available_bombs + 1, max_bombs)

func _apply_movement(movement: Vector2, delta: float) -> void:
	var resulting_velocity := Vector3.ZERO
	
	if is_on_floor():
		if movement.length() > 0:
			resulting_velocity = Vector3(movement.x, 0, movement.y) * _speed
		else:
			resulting_velocity.x = move_toward(resulting_velocity.x, 0, _grounded_desacceleration)
			resulting_velocity.z = move_toward(resulting_velocity.z, 0, _grounded_desacceleration)
	else:
		resulting_velocity += get_gravity() * _mass * delta
	
	velocity = resulting_velocity
	
	move_and_slide()

func _rotate_visuals(direction: Vector2, delta: float) -> void:
	if direction.length() > 0:
		var look_direction = Vector2(direction.y, direction.x)
		var current_rotation = visuals.rotation.y
		var acceleration = _rotation_acceleration * delta
		var new_rotation = lerp_angle(current_rotation, look_direction.angle(), acceleration)
		visuals.rotation.y = new_rotation
