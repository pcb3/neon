extends CharacterBody2D

var player_data =preload("res://resources/PlayerData.tres")

#@export var move_speed = 200a

#@export var jump_height : float
#@export var jump_time_to_peak : float
#@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * player_data.jump_height) / player_data.jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * player_data.jump_height) / (player_data.jump_time_to_peak * player_data.jump_time_to_peak)) * -1.0
@export var fall_gravity : float = ((-2.0 * player_data.jump_height) / (player_data.jump_time_to_descent * player_data.jump_time_to_descent)) * -1.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * player_data.speed
	else:
		velocity.x = move_toward(velocity.x, 0, player_data.speed)

	move_and_slide()
