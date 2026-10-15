extends Control

const ESCENA_FINAL = "res://Scenes/cinematicas_nuevas/pensando cosas gg.tscn"

func _ready():
	$VideoStreamPlayer.grab_focus()

func _on_video_stream_player_finished():
	TransitionLayer.change_scene(ESCENA_FINAL)
