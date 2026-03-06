class_name WeaponHolder
extends Node2D

## Manages the currently equipped weapon.
## Attach this to the WeaponHolder node (formerly LongSword) in the Hunter scene.
## Call equip() / unequip() to swap weapons.
## Call play_attack(direction) from either PlayerController or AIController.

signal attack_started(weapon: WeaponData)
signal attack_finished(weapon: WeaponData)

@export var equipped_weapon: WeaponData

@onready var sprite: Sprite2D = $SpriteWeapon
@onready var anim_player: AnimationPlayer = $AnimationWeapon

var _is_attacking: bool = false


func _ready() -> void:
	anim_player.animation_finished.connect(_on_animation_finished)
	sprite.visible = false
	# Apply the default equipped weapon if set in Inspector
	if equipped_weapon:
		_apply_weapon_visuals(equipped_weapon)


# ─── Public API ───────────────────────────────────────────────────────────────

## Equip a new weapon. Pass null to unequip.
func equip(weapon: WeaponData) -> void:
	equipped_weapon = weapon
	_is_attacking = false
	sprite.visible = false

	if weapon == null:
		return

	_apply_weapon_visuals(weapon)


## Remove the current weapon.
func unequip() -> void:
	equip(null)


## Play the directional attack animation.
## direction: "up" | "down" | "left" | "right"
## Returns true if the attack started, false if already attacking or no weapon.
func play_attack(direction: String) -> bool:
	if _is_attacking or equipped_weapon == null:
		return false

	var anim_name: String = equipped_weapon.attack_animations.get(direction, "")
	if anim_name.is_empty() or not anim_player.has_animation(anim_name):
		push_warning("WeaponHolder: No animation '%s' found for direction '%s'" % [anim_name, direction])
		return false

	_is_attacking = true
	anim_player.play(anim_name)
	attack_started.emit(equipped_weapon)
	return true


## Returns whether an attack animation is currently playing.
func is_attacking() -> bool:
	return _is_attacking


## Play the directional walk animation. Ignored during an attack.
## direction: "up" | "down" | "left" | "right"
func play_walk(direction: String) -> void:
	if _is_attacking:
		return
	var anim_name := "walk_" + direction
	if anim_player.has_animation(anim_name) and anim_player.current_animation != anim_name:
		anim_player.play(anim_name)


## Stop the walk animation and hide the weapon sprite.
func stop_walk() -> void:
	if _is_attacking:
		return
	anim_player.stop()
	sprite.visible = false


# ─── Internal ─────────────────────────────────────────────────────────────────

func _apply_weapon_visuals(weapon: WeaponData) -> void:
	sprite.texture = weapon.sprite_texture
	sprite.hframes = weapon.hframes
	sprite.vframes = weapon.vframes


func _on_animation_finished(_anim_name: String) -> void:
	_is_attacking = false
	sprite.visible = false
	attack_finished.emit(equipped_weapon)
