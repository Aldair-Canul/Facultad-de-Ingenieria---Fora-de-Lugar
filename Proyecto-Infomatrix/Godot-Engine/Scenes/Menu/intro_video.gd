extends Control

const ESCENA_SIGUIENTE = "res://Scenes/Mini_Juego_Cuarto/LlegandoCasa.tscn"

func _ready():
	$VideoStreamPlayer.grab_focus()

func _on_video_stream_player_finished() -> void:
	TransitionLayer.change_scene(ESCENA_SIGUIENTE)
