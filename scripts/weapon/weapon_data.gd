class_name WeaponData
extends Resource

## Defines a weapon's visual and animation data.
## Create .tres instances of this resource for each weapon type.

@export var weapon_name: String = ""
@export var weapon_type: String = "melee"  # "melee", "ranged", "magic"

# Sprite sheet config
@export var sprite_texture: Texture2D
@export var hframes: int = 6
@export var vframes: int = 4

# Maps direction -> animation name in the WeaponHolder's AnimationPlayer
# Directions: "up", "down", "left", "right"
@export var attack_animations: Dictionary = {
	"up":    "",
	"down":  "",
	"left":  "",
	"right": ""
}

# The body animation key to play when attacking (used on the hunter's AnimationTree)
# e.g. "slash" for melee, "shoot" for bow
@export var body_attack_anim: String = "slash"

# Duration of the attack animation in seconds (used to block input during attack)
@export var attack_duration: float = 0.5
