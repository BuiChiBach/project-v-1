extends Node2D

# Character type enumeration
enum CharacterType { MALE, FEMALE, SKELETON, ZOMBIE }

# Texture paths for different character types
var texture_paths = {
	CharacterType.MALE: {
		"body": "res://assets/sprites/hunters/male_body_base.png",
		"head": "res://assets/sprites/hunters/male_head_base.png"
	},
	CharacterType.FEMALE: {
		"body": "res://assets/sprites/hunters/female_body_base.png",
		"head": "res://assets/sprites/hunters/female_head_base.png"
	},
	CharacterType.SKELETON: {
		"body": "res://assets/sprites/hunters/skeleton_body_base.png",
		"head": "res://assets/sprites/hunters/skeleton_head_base.png"
	},
	CharacterType.ZOMBIE: {
		"body": "res://assets/sprites/hunters/zombie_body_base.png",
		"head": "res://assets/sprites/hunters/zombie_head_base.png"
	}
}

@onready var body_sprite = $Body
@onready var head_sprite = $Head


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


# Set character appearance by type
func set_character_type(char_type: CharacterType) -> void:
	if char_type in texture_paths:
		var textures = texture_paths[char_type]
		body_sprite.texture = load(textures["body"])
		head_sprite.texture = load(textures["head"])


# Alternative: Set custom textures directly
func set_character_textures(body_texture_path: String, head_texture_path: String) -> void:
	body_sprite.texture = load(body_texture_path)
	head_sprite.texture = load(head_texture_path)
