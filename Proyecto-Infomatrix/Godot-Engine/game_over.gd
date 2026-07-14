extends Control

func _on_button_pressed():
	# Quitamos cualquier pausa por si acaso
	get_tree().paused = false 
	
	# Cambiamos a la calle usando su ubicación real
	get_tree().change_scene_to_file("res://Scenes/Mini_Juego_Mesero/nodo_calle.tscn")
