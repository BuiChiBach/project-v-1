extends CharacterBody2D


const SPEED = 300.0

@onready var visual = $Visual
@onready var animation_tree = $Visual/AnimationTree
@onready var weapon_holder: WeaponHolder = $WeaponHolder
@onready var _playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

var movement_direction := Vector2.ZERO
var facing_direction := Vector2.DOWN  # Last non-zero direction (for attack facing)
var _is_attacking := false


func _ready() -> void:
	animation_tree.active = true

	# Listen for attack events from weapon holder
	weapon_holder.attack_started.connect(_on_attack_started)
	weapon_holder.attack_finished.connect(_on_attack_finished)


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
			KEY_5:
				# Swap to amber palette
				visual.swap_head_body_palette("res://assets/palette/body/light.png", "res://assets/palette/body/amber.png", 6)
			KEY_6:
				# Swap back to light palette (remove shader)
				visual.body_sprite.material = null
				visual.head_sprite.material = null
				print("Reset body to original palette")

	# Attack input — left mouse button or dedicated attack key
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		attack()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		attack()


func _physics_process(delta: float) -> void:
	movement_direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	if movement_direction.length() > 0:
		movement_direction = movement_direction.normalized()
		facing_direction = movement_direction  # Track last faced direction

	# Freeze movement while attacking
	if _is_attacking:
		velocity = Vector2.ZERO
	else:
		velocity = movement_direction * SPEED

	move_and_slide()

	if movement_direction != Vector2.ZERO and not _is_attacking:
		animation_tree["parameters/Idle/blend_position"] = movement_direction
		animation_tree["parameters/Walk/blend_position"] = movement_direction
		weapon_holder.play_walk(_get_facing_string())
	elif not _is_attacking:
		weapon_holder.stop_walk()


# ─── Public Action API (callable by PlayerController OR AIController) ─────────

## Trigger an attack in the current facing direction.
func attack() -> void:
	if _is_attacking:
		return
	var dir = _get_facing_string()
	# Snap to the cardinal vector so body and weapon always agree
	animation_tree["parameters/Slash/blend_position"] = _direction_string_to_vector(dir)

	# Travel to Slash state — smoothly interrupts Idle or Walk
	_playback.travel("Slash")

	# Play the weapon overlay animation in sync
	weapon_holder.play_attack(dir)


## Equip a weapon by WeaponData resource.
func equip_weapon(weapon: WeaponData) -> void:
	weapon_holder.equip(weapon)


## Unequip the current weapon.
func unequip_weapon() -> void:
	weapon_holder.unequip()


## Set the character type (MALE, FEMALE, SKELETON, ZOMBIE).
func set_character_type(char_type: int) -> void:
	visual.set_character_type(char_type)


# ─── Internal ─────────────────────────────────────────────────────────────────

func _get_facing_string() -> String:
	# X-axis priority: horizontal wins on a perfect 45° diagonal
	if abs(facing_direction.x) >= abs(facing_direction.y):
		return "right" if facing_direction.x >= 0 else "left"
	else:
		return "down" if facing_direction.y >= 0 else "up"


func _direction_string_to_vector(dir: String) -> Vector2:
	match dir:
		"up":    return Vector2.UP
		"down":  return Vector2.DOWN
		"left":  return Vector2.LEFT
		"right": return Vector2.RIGHT
	return Vector2.DOWN


func _on_attack_started(_weapon: WeaponData) -> void:
	_is_attacking = true


func _on_attack_finished(_weapon: WeaponData) -> void:
	_is_attacking = false
