class_name Player
extends CharacterBody2D

@export var player_data = preload("res://resources/PlayerData.tres")

@onready var jump_velocity : float = ((2.0 * player_data.jump_height) / player_data.jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * player_data.jump_height) / (player_data.jump_time_to_peak * player_data.jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * player_data.jump_height) / (player_data.jump_time_to_descent * player_data.jump_time_to_descent)) * -1.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_custom_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * player_data.speed
	else:
		velocity.x = move_toward(velocity.x, 0, player_data.speed)

	move_and_slide()
	
	# Set velocity to 0 when grounded
	if is_on_floor():
		velocity.y = 0.0
		
	print("velocity: ", velocity)

func get_custom_gravity() -> Vector2:
	return Vector2(0, jump_gravity) if velocity.y < 0.0 else Vector2(0, fall_gravity)
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():  # Run in editor
			jump_velocity = ((2.0 * player_data.jump_height) / player_data.jump_time_to_peak) * -1.0
			jump_gravity = ((-2.0 * player_data.jump_height) / (player_data.jump_time_to_peak * player_data.jump_time_to_peak)) * -1.0
			fall_gravity = ((-2.0 * player_data.jump_height) / (player_data.jump_time_to_descent * player_data.jump_time_to_descent)) * -1.0
