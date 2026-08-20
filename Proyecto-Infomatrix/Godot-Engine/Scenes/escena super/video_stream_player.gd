extends VideoStreamPlayer

@export var siguiente_escena: String = "res://ruta/a/tu_escena.tscn"

func _ready() -> void:
	play()
	finished.connect(_on_video_finished)

func _input(event: InputEvent) -> void:
	# Permite saltar el video presionando cualquier tecla o clic
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			_saltar_video()

func _saltar_video() -> void:
	stop()
	_on_video_finished()

func _on_video_finished() -> void:
	if siguiente_escena != "":
		get_tree().change_scene_to_file(siguiente_escena)
