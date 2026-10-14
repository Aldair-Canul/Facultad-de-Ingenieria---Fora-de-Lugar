extends Control

const ESCENA_FINAL = "res://Scenes/cinematicas_nuevas/pensando cosas gg.tscn"

func _ready():
	$VideoStreamPlayer.grab_focus()

func _on_video_stream_player_finished():
	TransitionLayer.change_scene(ESCENA_FINAL)
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		# Detiene el video y nos manda directo al menú
		TransitionLayer.change_scene(ESCENA_FINAL)
