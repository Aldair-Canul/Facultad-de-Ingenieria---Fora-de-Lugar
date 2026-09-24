extends Node2D

@onready var check_barrer: CheckBox = $CanvaUI/PanelTareas/TareaBarrer
@onready var check_recoger: CheckBox = $CanvaUI/PanelTareas/TareaRecoger
@onready var check_tirar: CheckBox = $CanvaUI/PanelTareas/TareaTirar

@onready var basura_node: Area2D = $CanvaUI/PanelTareas/Basura
@onready var basurero_node: Area2D = $CanvaUI/PanelTareas/Basurero

var fase_actual: int = 1

func _ready() -> void:
	# Ocultar tareas secundarias al inicio
	check_recoger.visible = false
	check_tirar.visible = false
	basura_node.visible = false
	basura_node.monitoring = false

	# Conectar señales
	basura_node.basura_recogida.connect(_on_basura_recogida)
	basurero_node.basura_depositada.connect(_on_basura_depositada)

func _process(_delta: float) -> void:
	# FASE 1: Revisar si terminó de barrer
	if fase_actual == 1:
		var polvos_restantes := get_tree().get_nodes_in_group("polvos").size()
		if polvos_restantes == 0:
			fase_actual = 2
			check_barrer.button_pressed = true
			
			# Revelar la Tarea 2 y hacer aparecer la bolsa de basura
			check_recoger.visible = true
			basura_node.visible = true
			basura_node.monitoring = true

func _on_basura_recogida() -> void:
	# FASE 2 Completada: Recogió la bolsa
	fase_actual = 3
	check_recoger.button_pressed = true
	
	# Revelar la Tarea 3 y habilitar el basurero
	check_tirar.visible = true
	basurero_node.activar_interaccion()

func _on_basura_depositada() -> void:
	# FASE 3 Completada: Tiró la basura
	check_tirar.button_pressed = true
	
	# Opcional: Esperar 1 segundo para que el jugador vea la casilla marcada
	await get_tree().create_timer(1.0).timeout
	
	# Cambiar a la pantalla de carga
	get_tree().change_scene_to_file("res://Scenes/Mini_Juego_Cuarto/PantallaCarga.tscn")
