extends Control

const ESCENA_SIGUIENTE = "res://Scenes/Escena_mercado/mercado.tscn"

func _ready():
	$VideoStreamPlayer.grab_focus()

func _on_video_stream_player_finished():
	TransitionLayer.change_scene(ESCENA_SIGUIENTE)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		# Detiene el video y nos manda directo al menú
		TransitionLayer.change_scene(ESCENA_SIGUIENTE)
