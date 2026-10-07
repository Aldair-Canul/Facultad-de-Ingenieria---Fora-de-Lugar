extends Button


func _on_boton_pressed():
	get_node("../AudioStreamPlayer2D").stop()
	TransitionLayer.change_scene("res://Scenes/Mini_Juego_Cuarto/LlegandoCasa.tscn")
