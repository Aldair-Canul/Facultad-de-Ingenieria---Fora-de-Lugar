extends Control

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

# Ruta hacia la siguiente escena a la que irá el jugador después del video
const RUTA_SIGUIENTE_ESCENA: String = "res://Scenes/Escena_mercado/encontrar_trabajo.tscn" # Cambia esta ruta por la tuya

func _ready() -> void:
	# Conectamos la señal que avisa cuando el video termina
	video_player.finished.connect(_al_terminar_video)

func _al_terminar_video() -> void:
	# Cambia a la siguiente escena automáticamente
	get_tree().change_scene_to_file(RUTA_SIGUIENTE_ESCENA)

# Opcional: Permitir al jugador saltar el video si presiona Enter/Espacio/Esc
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		_al_terminar_video()
