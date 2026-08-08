extends Button

	


func _on_pressed() -> void:
	get_node("../AudioStreamPlayer2D").stop()
	get_tree().change_scene_to_file("res://Scenes/Juego_Cuarto/intro_cuarto.tscn")
