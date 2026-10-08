extends Control

# Ruta de la escena a la que quieres ir al presionar el botón
@export_file("*.tscn") var siguiente_escena: String = "res://Scenes/Mini_Juego_Cuarto/PantallaCarga.tscn"

@onready var boton_continuar: Button = $BtnSiguiente 

func _ready() -> void:
	# No necesitas .connect() aquí porque la señal ya está vinculada desde el editor
	pass

func _on_btn_siguiente_pressed() -> void:
	if has_node("/root/TransitionLayer"):
		TransitionLayer.change_scene(siguiente_escena)
	else:
		TransitionLayer.change_scene(siguiente_escena)
