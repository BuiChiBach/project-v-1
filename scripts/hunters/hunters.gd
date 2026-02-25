extends CharacterBody2D


const SPEED = 300.0

@onready var visual = $Visual
@onready var animation_tree = $Visual/AnimationTree
var movement_direction = Vector2.ZERO
var last_direction = Vector2.DOWN

func _ready() -> void:
	animation_tree.active = true


func _input(event: InputEvent) -> void:
	# Test buttons to switch character types
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				set_character_type(visual.CharacterType.MALE)
				print("Changed to MALE")
			KEY_2:
				set_character_type(visual.CharacterType.FEMALE)
				print("Changed to FEMALE")
			KEY_3:
				set_character_type(visual.CharacterType.SKELETON)
				print("Changed to SKELETON")
			KEY_4:
				set_character_type(visual.CharacterType.ZOMBIE)
				print("Changed to ZOMBIE")


func _physics_process(delta: float) -> void:
	movement_direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	if movement_direction.length() > 0:
		movement_direction = movement_direction.normalized()
		last_direction = movement_direction

	velocity = movement_direction * SPEED
	move_and_slide()
	
	# Prioritize y-direction over x-direction for animation
	var animation_direction = last_direction
	if last_direction.y != 0:
		animation_direction = Vector2(0, last_direction.y)
	
	animation_tree["parameters/Idle/blend_position"] = animation_direction
	animation_tree["parameters/Walk/blend_position"] = animation_direction


# Set the character type (MALE, FEMALE, or ENEMY)
func set_character_type(char_type: int) -> void:
	visual.set_character_type(char_type)
