extends Control

const ESCENA_MENU = "res://Scenes/Menu/MenuInicio.tscn"

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:
	# 1. Esperar un fotograma para dejar que el motor web inicialice la gráfica
	await get_tree().process_frame
	
	# 2. Iniciar la carga del Menú en segundo plano MIENTRAS se reproduce el video
	ResourceLoader.load_threaded_request(ESCENA_MENU)
	
	video_player.grab_focus()

func _on_video_stream_player_finished() -> void:
	# 3. Al terminar el video, recuperamos el menú ya procesado en memoria RAM
	var estado := ResourceLoader.load_threaded_get_status(ESCENA_MENU)
	
	if estado == ResourceLoader.THREAD_LOAD_LOADED:
		var menu_cargado = ResourceLoader.load_threaded_get(ESCENA_MENU)
		# Si tu TransitionLayer acepta PackedScene:
		if TransitionLayer.has_method("change_scene_to_packed"):
			TransitionLayer.change_scene_to_packed(menu_cargado)
		else:
			get_tree().change_scene_to_packed(menu_cargado)
	else:
		# Fallback por si el video duró muy poco o la carga no ha finalizado
		TransitionLayer.change_scene(ESCENA_MENU)
