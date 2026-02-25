extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var visual = $Visual
@onready var animation_player = $Visual/AnimationPlayer

var last_direction = Vector2.DOWN


func _ready() -> void:
	# Default to male, can be changed via set_character_type()
	pass


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	# Handle horizontal movement
	if direction_x:
		velocity.x = direction_x * SPEED
		
		# Play walk animation based on direction
		if direction_x > 0:
			animation_player.play("walk_right")
			last_direction = Vector2.RIGHT
		else:
			animation_player.play("walk_left")
			last_direction = Vector2.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle vertical movement
	if direction_y:
		velocity.y = direction_y * SPEED
		
		# Play walk animation based on direction
		if direction_y > 0:
			animation_player.play("walk_down")
			last_direction = Vector2.DOWN
		else:
			animation_player.play("walk_up")
			last_direction = Vector2.UP
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	# Play idle animation based on last direction (when not moving)
	if direction_x == 0 and direction_y == 0:
		if last_direction == Vector2.RIGHT:
			animation_player.play("idle_right")
		elif last_direction == Vector2.LEFT:
			animation_player.play("idle_left")
		elif last_direction == Vector2.UP:
			animation_player.play("idle_up")
		else:
			animation_player.play("idle_down")

	move_and_slide()


# Set the character type (MALE, FEMALE, or ENEMY)
func set_character_type(char_type: int) -> void:
	visual.set_character_type(char_type)
