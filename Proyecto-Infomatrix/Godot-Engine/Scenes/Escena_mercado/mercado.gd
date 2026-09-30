extends Node2D

@onready var boton_siguiente: Button = $BotonSiguiente
const RUTA_CINEMATICA: String = "res://Scenes/Escena_mercado/control.tscn"

func _ready() -> void:
	# botón solo será visible si super_visitado es true
	boton_siguiente.visible = DatosJugador.super_visitado
	
	# Conectamos el botón
	boton_siguiente.pressed.connect(_on_boton_siguiente_pressed)

func _on_boton_siguiente_pressed() -> void:
	get_tree().change_scene_to_file(RUTA_CINEMATICA)
