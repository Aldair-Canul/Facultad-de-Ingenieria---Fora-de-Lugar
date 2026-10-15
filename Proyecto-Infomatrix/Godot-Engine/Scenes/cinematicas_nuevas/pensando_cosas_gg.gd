extends Control

const ESCENA_SIGUIENTE = "res://Scenes/cinematicas_nuevas/llorando.tscn"

func _ready():
	$VideoStreamPlayer.grab_focus()

func _on_video_stream_player_finished():
	TransitionLayer.change_scene(ESCENA_SIGUIENTE)
