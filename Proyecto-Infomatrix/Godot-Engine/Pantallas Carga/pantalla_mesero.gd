extends Control

@onready var barra_progreso: ProgressBar = $ProgressBar # o TextureProgressBar si usaste esa
@onready var temporizador: Timer = $Timer


const ESCENA_SIGUIENTE: String = "res://Scenes/Mini_Juego_Mesero/nodo_calle.tscn"

func _ready() -> void:
	barra_progreso.value = 0
	temporizador.timeout.connect(_al_terminar_tiempo)

func _process(_delta: float) -> void:
	if not temporizador.is_stopped():
		var avance = (1.0 - (temporizador.time_left / temporizador.wait_time)) * 100.0
		barra_progreso.value = avance

func _al_terminar_tiempo() -> void:
	TransitionLayer.change_scene(ESCENA_SIGUIENTE)
