extends CharacterBody3D

var _rotation_acceleration: float = 10
var _grounded_desacceleration: float = 0
var _speed: float = 8
var _mass: float = 15

@onready var visuals: Node3D = %Visuals

@export var bomb_scene: PackedScene
@export var max_bombs: int = 1

var _available_bombs: int

func _ready() -> void:
	_available_bombs = max_bombs

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("drop_bomb") and _available_bombs > 0):
		var bomb = bomb_scene.instantiate()
		add_child(bomb)
		bomb.global_position = Vector3(global_position)
		bomb.global_position.y = 0.5
		bomb.exploded.connect(_refill_bombs)
		
		_available_bombs -= 1

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("walk_left", "walk_right", "walk_forward", "walk_backward").normalized()
	
	#if not direction == Vector2.ZERO and is_on_floor():
		#visuals.play("Running_A")
	#else:
		#visuals.play("Idle")

	_rotate_visuals(direction, delta)
	_apply_movement(direction, delta)

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
