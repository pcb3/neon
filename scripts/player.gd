extends CharacterBody2D

var player_data =preload("res://resources/PlayerData.tres")

# State machine
enum State { IDLE, RUNNING, JUMPING, FALLING }
var state : State = State.IDLE

func _physics_process(delta: float) -> void:
	# Get horizontal input
	var input_x: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	# State machine
	match state:
		State.IDLE:
			# Transition to RUNNING if moving
			if input_x != 0:
				state = State.RUNNING
			# Transition to JUMPING if jumping
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = -player_data.jump_force
				state = State.JUMPING
			# Apply gravity
			velocity.y += player_data.gravity * delta
			# Decelerate on ground
			velocity.x = move_toward(velocity.x, 0, player_data.acceleration * delta)
		
		State.RUNNING:
			# Transition to IDLE if no input
			if input_x == 0:
				state = State.IDLE
			# Transition to JUMPING if jumping
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = -player_data.jump_force
				state = State.JUMPING
			# Move horizontally
			velocity.x = move_toward(velocity.x, input_x * player_data.max_speed, player_data.acceleration * delta)
			# Apply gravity
			velocity.y += player_data.gravity * delta
			
		State.JUMPING:
			# Transition to falling when velocity becomes positive
			if velocity.y >= 0:
				state = State.FALLING
			# Move horizontally
			velocity.x = move_toward(velocity.x, input_x * player_data.max_speed, player_data.acceleration * delta)
			# Apply gravity
			velocity.y += player_data.gravity * delta
	# Apply movement
	move_and_slide()
