extends Control

const ESCENA_SIGUIENTE = "res://Pantallas Carga/pantalla_super.tscn"

func _ready():
	$VideoStreamPlayer.grab_focus()

func _on_video_stream_player_finished():
	TransitionLayer.change_scene(ESCENA_SIGUIENTE)
