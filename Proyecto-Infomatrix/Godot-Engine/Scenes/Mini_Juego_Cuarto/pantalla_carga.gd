extends Control

# Ruta de la escena a la que se cambiará tras los 4 segundos
# Puedes cambiar la ruta predeterminada o asignarla desde el Inspector
@export_file("*.tscn") var siguiente_escena: String = "res://Scenes/Mini_Juego_Cuarto/mini_juego_cuarto.tscn"
@onready var sprite_animado: AnimatedSprite2D = $AnimatedSprite2D
func _ready() -> void:
	sprite_animado.play("default")
	# 1. Esperar 4 segundos exactamente
	await get_tree().create_timer(4.0).timeout
	
	# 2. Cambiar a la escena del siguiente nivel
	get_tree().change_scene_to_file(siguiente_escena)
