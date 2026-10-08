extends Node2D

@export var meta_platillos: int = 5
@export var ruta_cinematica: String = "res://Pantallas Carga/Final_juego.tscn"

var platillos_entregados: int = 0
var juego_completado: bool = false

const PRE_PLATO = preload("res://Scenes/Mini_Juego_Mesero/plato.tscn")

var imagenes_comida = [
	preload("res://images/Mesero/comida1.png"), 
	preload("res://images/Mesero/comida2.png"), 
	preload("res://images/Mesero/comida3.png"),
	preload("res://images/Mesero/comida4.png"), 
	preload("res://images/Mesero/comida5.png")  
]

var posiciones_puertas = [
	Vector2(300, 210),  
	Vector2(580, 210),  
	Vector2(830, 210)   
]

func _ready():
	$Timer.timeout.connect(_generar_plato_aleatorio)
	if $CanvasLayer.has_method("actualizar_platillos"):
		$CanvasLayer.actualizar_platillos(platillos_entregados, meta_platillos)

func _generar_plato_aleatorio():
	if juego_completado:
		return
		
	var nuevo_plato = PRE_PLATO.instantiate()
	var mesa_al_azar = randi_range(1, 6)
	var comida_al_azar = imagenes_comida[randi_range(0, imagenes_comida.size() - 1)]
	var puerta_al_azar = posiciones_puertas[randi_range(0, posiciones_puertas.size() - 1)]
	
	nuevo_plato.position = puerta_al_azar
	nuevo_plato.configurar_plato(mesa_al_azar, comida_al_azar)
	add_child(nuevo_plato)
	$SonidoCampana.play()

func registrar_platillo_entregado() -> void:
	if juego_completado:
		return
		
	platillos_entregados += 1
	if $CanvasLayer.has_method("actualizar_platillos"):
		$CanvasLayer.actualizar_platillos(platillos_entregados, meta_platillos)
		
	if platillos_entregados >= meta_platillos:
		completar_nivel()

func completar_nivel() -> void:
	juego_completado = true
	$Timer.stop()
	
	# Pausa breve para dar retroalimentación al jugador
	await get_tree().create_timer(1.0).timeout
	
	if TransitionLayer.has_method("cambiar_escena"):
		TransitionLayer.cambiar_escena(ruta_cinematica)
	elif TransitionLayer.has_method("change_scene"):
		TransitionLayer.change_scene(ruta_cinematica)
	else:
		# Respaldo por si el método en TransitionLayer tiene otro nombre
		get_tree().call_deferred("change_scene_to_file", ruta_cinematica)
