class_name Player
extends CharacterBody2D

@export var player_data = preload("res://resources/PlayerData.tres")

@onready var jump_velocity : float = ((2.0 * player_data.jump_height) / player_data.jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * player_data.jump_height) / (player_data.jump_time_to_peak * player_data.jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * player_data.jump_height) / (player_data.jump_time_to_descent * player_data.jump_time_to_descent)) * -1.0

@onready var is_dashing: bool = false
@onready var can_dash: float = false
@onready var dash_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Set velocity to 0 when grounded
	if is_on_floor():
		velocity.y = 0.0
		can_dash = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_custom_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_velocity

	# Set direction vector and move player
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("jump", "down")
	var direction := Vector2(direction_x, direction_y)
	if direction_x:
		velocity.x = direction_x * player_data.speed
	else:
		velocity.x = move_toward(velocity.x, 0, player_data.speed)

	# Handle dsah.
	if Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		if direction.length() == 0:
			direction = Vector2.RIGHT
		else:
			direction = direction.normalized()
		velocity = direction * player_data.dash_speed
		can_dash = false

	move_and_slide()

func get_custom_gravity() -> Vector2:
	return Vector2(0, jump_gravity) if velocity.y < 0.0 else Vector2(0, fall_gravity)
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():  # Run in editor
			jump_velocity = ((2.0 * player_data.jump_height) / player_data.jump_time_to_peak) * -1.0
			jump_gravity = ((-2.0 * player_data.jump_height) / (player_data.jump_time_to_peak * player_data.jump_time_to_peak)) * -1.0
			fall_gravity = ((-2.0 * player_data.jump_height) / (player_data.jump_time_to_descent * player_data.jump_time_to_descent)) * -1.0
