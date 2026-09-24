extends Control

# Asigna la ruta de la siguiente escena en el Inspector
@export_file("*.tscn") var siguiente_escena: String = "res://Scenes/Mini_Juego_Cuarto/final_cuarto.tscn"
@onready var sprite_animado: AnimatedSprite2D = $AnimatedSprite2D
@onready var label_mensaje: Label = $Label

func _ready() -> void:
	sprite_animado.play("default")
	# 1. Crear animación de parpadeo (desvanecer texto de 100% a 20% de opacidad)
	var tween := create_tween().set_loops()
	tween.tween_property(label_mensaje, "modulate:a", 0.1, 0.6)
	tween.tween_property(label_mensaje, "modulate:a", 1.0, 0.6)
	
	# 2. Esperar 3 segundos exactos
	await get_tree().create_timer(3.0).timeout
	
	# 3. Cambiar a la siguiente escena
	get_tree().change_scene_to_file(siguiente_escena)
