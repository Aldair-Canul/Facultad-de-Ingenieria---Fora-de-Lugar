extends Node2D

# Cargamos el molde único del plato
const PRE_PLATO = preload("res://Scenes/Mini_Juego_Mesero/plato.tscn")

# Lista de los 5 platos
var imagenes_comida = [
	preload("res://images/Mesero/comida1.png"), # Tacos
	preload("res://images/Mesero/comida2.png"), # Hotdog
	preload("res://images/Mesero/comida3.png"), # Hamburguesa
	preload("res://images/Mesero/comida4.png"), # Carne
	preload("res://images/Mesero/comida5.png")  # Gorditas
]

# Coordenadas X e Y de las puertas 
var posiciones_puertas = [
	Vector2(300, 210),  # Puerta 1 (Izquierda)
	Vector2(580, 210),  # Puerta 2 (Centro)
	Vector2(830, 210)   # Puerta 3 (Derecha)
]

func _ready():
	# Cada vez que el reloj termine, creará un plato
	$Timer.timeout.connect(_generar_plato_aleatorio)

func _generar_plato_aleatorio():
	var nuevo_plato = PRE_PLATO.instantiate()
	
	# Elegimos mesa destino al azar (1 a 6)
	var mesa_al_azar = randi_range(1, 6)
	
	# Elegimos una comida al azar de las 5 disponibles
	var comida_al_azar = imagenes_comida[randi_range(0, imagenes_comida.size() - 1)]
	
	# Elegimos una puerta al azar de las 3 disponibles para que nazca ahí
	var puerta_al_azar = posiciones_puertas[randi_range(0, posiciones_puertas.size() - 1)]
	
	# Configuramos la posición de nacimiento del plato
	nuevo_plato.position = puerta_al_azar
	
	# Le pasamos los datos al plato para que los guarde
	nuevo_plato.configurar_plato(mesa_al_azar, comida_al_azar)
	
	# Metemos el plato dentro de la calle para que aparezca en pantalla
	add_child(nuevo_plato)
	
	$SonidoCampana.play()
