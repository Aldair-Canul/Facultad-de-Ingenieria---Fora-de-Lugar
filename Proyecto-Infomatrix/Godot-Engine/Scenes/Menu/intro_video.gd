extends Control

const ESCENA_SIGUIENTE = "res://Scenes/Mini_Juego_Cuarto/LlegandoCasa.tscn"
const RUTA_VIDEO = "res://images/MenuInicio/video-combi-intro.ogv"

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:
	# 1. Cargar el paquete que contiene las cinemáticas
	if FileAccess.file_exists("res://cinematicas.pck"):
		ProjectSettings.load_resource_pack("res://cinematicas.pck")
	
	# 2. Esperar un fotograma a que el motor registre los archivos del PCK
	await get_tree().process_frame

	# 3. Cargar el video dinámicamente y reproducirlo
	if ResourceLoader.exists(RUTA_VIDEO):
		video_player.stream = load(RUTA_VIDEO)
		video_player.play()
		video_player.grab_focus()
	else:
		push_error("No se pudo encontrar el video en: " + RUTA_VIDEO)
		_cambiar_escena()

func _on_video_stream_player_finished() -> void:
	_cambiar_escena()

func _cambiar_escena() -> void:
	if has_node("/root/TransitionLayer"):
		TransitionLayer.change_scene(ESCENA_SIGUIENTE)
	else:
		get_tree().change_scene_to_file(ESCENA_SIGUIENTE)
