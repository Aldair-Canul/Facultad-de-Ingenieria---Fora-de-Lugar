extends Control

@onready var barra_progreso: ProgressBar = $BarraProgreso # o TextureProgressBar si usaste esa
@onready var temporizador: Timer = $Temporizador


const RUTA_MERCADO: String = "res://Scenes/Escena_mercado/mercado.tscn"

func _ready() -> void:
	barra_progreso.value = 0
	temporizador.timeout.connect(_al_terminar_tiempo)

func _process(_delta: float) -> void:
	if not temporizador.is_stopped():
		var avance = (1.0 - (temporizador.time_left / temporizador.wait_time)) * 100.0
		barra_progreso.value = avance

func _al_terminar_tiempo() -> void:
	get_tree().change_scene_to_file(RUTA_MERCADO)
