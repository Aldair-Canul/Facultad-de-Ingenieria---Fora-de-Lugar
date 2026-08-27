extends Node2D


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

func _generar_plato_aleatorio():
	var nuevo_plato = PRE_PLATO.instantiate()
	
	
	var mesa_al_azar = randi_range(1, 6)
	
	
	var comida_al_azar = imagenes_comida[randi_range(0, imagenes_comida.size() - 1)]
	
	
	var puerta_al_azar = posiciones_puertas[randi_range(0, posiciones_puertas.size() - 1)]
	
	
	nuevo_plato.position = puerta_al_azar
	
	
	nuevo_plato.configurar_plato(mesa_al_azar, comida_al_azar)
	
	
	add_child(nuevo_plato)
	
	$SonidoCampana.play()
