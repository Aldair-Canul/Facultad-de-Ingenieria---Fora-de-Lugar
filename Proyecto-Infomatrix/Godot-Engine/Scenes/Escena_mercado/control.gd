extends Control

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

# Ruta hacia la siguiente escena a la que irá el jugador después del video
const RUTA_SIGUIENTE_ESCENA: String = "res://Scenes/Escena_mercado/contando_dinero.tscn"
func _ready() -> void:
	# Conectamos la señal que avisa cuando el video termina
	video_player.finished.connect(_al_terminar_video)

func _al_terminar_video() -> void:
	# Cambia a la siguiente escena automáticamente
	TransitionLayer.change_scene(RUTA_SIGUIENTE_ESCENA)
