extends Control

const ESCENA_SIGUIENTE = "res://Scenes/Mini_Juego_Cuarto/intro_cuarto.tscn"
const RUTA_VIDEO = "res://images/OGV/Llegando_a_casa.ogv"

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:
	# 1. Asegurar que el paquete de cinemáticas esté cargado
	if FileAccess.file_exists("res://cinematicas.pck"):
		ProjectSettings.load_resource_pack("res://cinematicas.pck")
	
	# 2. Dar 1 fotograma de espera para la inicialización en la web
	await get_tree().process_frame

	# 3. Cargar y reproducir el video dinámicamente
	if ResourceLoader.exists(RUTA_VIDEO):
		video_player.stream = load(RUTA_VIDEO)
		video_player.play()
		video_player.grab_focus()
	else:
		push_error("No se encontró el video en la ruta: " + RUTA_VIDEO)
		_cambiar_escena()

func _on_video_stream_player_finished() -> void:
	_cambiar_escena()

func _cambiar_escena() -> void:
	if has_node("/root/TransitionLayer"):
		TransitionLayer.change_scene(ESCENA_SIGUIENTE)
	else:
		get_tree().change_scene_to_file(ESCENA_SIGUIENTE)
