extends Control

# Ruta de la escena a la que se cambiará tras los 4 segundos
# Puedes cambiar la ruta predeterminada o asignarla desde el Inspector
@export_file("*.tscn") var siguiente_escena: String = "res://Scenes/Mini_Juego_Cuarto/cuarto.tscn"
@onready var barra_progreso: ProgressBar = $ProgressBar
@onready var temporizador: Timer = $Timer


func _ready() -> void:
	barra_progreso.value = 0
	temporizador.timeout.connect(_al_terminar_tiempo)

func _process(_delta: float) -> void:
	if not temporizador.is_stopped():
		var avance = (1.0 - (temporizador.time_left / temporizador.wait_time)) * 100.0
		barra_progreso.value = avance

func _al_terminar_tiempo() -> void:
	get_tree().change_scene_to_file(siguiente_escena)
