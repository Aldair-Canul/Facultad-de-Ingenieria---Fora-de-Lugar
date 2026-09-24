extends Control

@export_file("*.tscn") var siguiente_escena: String = "res://Scenes/Mini_Juego_Cuarto/intro_cuarto.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		await get_tree().create_timer(29.0).timeout
		get_tree().change_scene_to_file(siguiente_escena)
