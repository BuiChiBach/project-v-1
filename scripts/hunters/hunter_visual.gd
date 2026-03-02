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
		"body": "res://assets/sprites/enemies/skeleton_body_base.png",
		"head": "res://assets/sprites/enemies/skeleton_head_base.png"
	},
	CharacterType.ZOMBIE: {
		"body": "res://assets/sprites/enemies/zombie_body_base.png",
		"head": "res://assets/sprites/enemies/zombie_head_base.png"
	}
}

var swap_palette_shader_path = "res://shader/swap_palette.gdshader";

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


# Swap body palette using shader
func swap_head_body_palette(original_palette: String, new_palette: String, colors_count: int) -> void:
	var original_tex = load(original_palette)
	var new_tex = load(new_palette)
	var shader = load(swap_palette_shader_path)
	
	if original_tex == null or new_tex == null or shader == null:
		print("ERROR: Failed to load palette textures or shader")
		return
	
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("original_palette", original_tex)
	material.set_shader_parameter("new_palette", new_tex)
	material.set_shader_parameter("colors_count", colors_count)
	
	body_sprite.material = material
	head_sprite.material = material
	print("Swapped hea/body palette: %s → %s (colors: %d)" % [original_palette, new_palette, colors_count])
