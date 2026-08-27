extends Control

const ESCENA_SIGUIENTE = "res://Scenes/Mini_Juego_Mesero/nodo_calle.tscn"

func _ready():
	$VideoStreamPlayer.grab_focus()

func _on_video_stream_player_finished():
	get_tree().change_scene_to_file(ESCENA_SIGUIENTE)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		# Detiene el video y nos manda directo al menú
		get_tree().change_scene_to_file(ESCENA_SIGUIENTE)
