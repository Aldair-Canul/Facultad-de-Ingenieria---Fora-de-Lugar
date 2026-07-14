extends Button


func _on_boton_pressed():
	get_node("../AudioStreamPlayer2D").stop()
	get_tree().change_scene_to_file("res://Scenes/Mini_Juego_Mesero/nodo_calle.tscn")
