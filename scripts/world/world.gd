extends Node2D

@onready var environment: Node2D = $Environment

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HunterManager._ready()
