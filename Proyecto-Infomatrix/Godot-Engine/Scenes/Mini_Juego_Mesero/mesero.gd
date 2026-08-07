extends CharacterBody2D

@export var VELOCIDAD = 200.0
var numero_plato_actual = 0  # 0 significa manos vacías
var vidas = 3
var posicion_inicial: Vector2
var esta_inmune = false

# =========================================================
# SISTEMA DE DINERO Y PROPINA
# =========================================================
var dinero_total: int = 0
var label_dinero: Label

func _ready():
	# Guardamos la posición donde inicia el mesero al empezar el juego
	posicion_inicial = position
	
	# Buscamos el LabelDinero en la escena principal
	label_dinero = get_tree().current_scene.get_node_or_null("CanvasLayer/LabelDinero")
	actualizar_interfaz_dinero()

func _physics_process(_delta):
	var direccion_x = 0
	var direccion_y = 0

	# Usamos Input.is_physical_key_pressed, que lee el teclado directamente por hardware
	if Input.is_physical_key_pressed(KEY_RIGHT) or Input.is_physical_key_pressed(KEY_D):
		direccion_x = 1
		$PlatoCargado.position = Vector2(80, -100)
		
	elif Input.is_physical_key_pressed(KEY_LEFT) or Input.is_physical_key_pressed(KEY_A):
		direccion_x = -1
		$PlatoCargado.position = Vector2(-80, -100)
		
	if Input.is_physical_key_pressed(KEY_DOWN) or Input.is_physical_key_pressed(KEY_S):
		direccion_y = 1
	elif Input.is_physical_key_pressed(KEY_UP) or Input.is_physical_key_pressed(KEY_W):
		direccion_y = -1
	
	# Aplicamos el movimiento
	velocity.x = direccion_x * VELOCIDAD
	velocity.y = direccion_y * VELOCIDAD
	
	move_and_slide()
	position.x = clamp(position.x, 40, 960)
	position.y = clamp(position.y, 230, 575)
	
	# =========================================================
	# CONTROL DE ANIMACIONES Y AJUSTE DE TAMAÑO (ESCALA CORREGIDA)
	# =========================================================
	if direccion_y > 0:
		$AnimatedSprite2D.play("Abajo")
		$AnimatedSprite2D.scale = Vector2(0.9, 0.9)
		
		$PlatoCargado.position = Vector2(0, -38)
		$PlatoCargado.z_index = 1
		$TextoPlatoCargado.z_index = 1
		
	elif direccion_y < 0:
		$AnimatedSprite2D.play("Arriba")
		$AnimatedSprite2D.scale = Vector2(0.9, 0.9) 
		
		$PlatoCargado.position = Vector2(0, -50)
		$PlatoCargado.z_index = -1  # Esconde el plato tras la espalda
		$TextoPlatoCargado.z_index = -1
		
	elif direccion_x > 0:
		$AnimatedSprite2D.play("Derecha")
		$AnimatedSprite2D.scale = Vector2(1.0, 1.0)
		$PlatoCargado.z_index = 1
		$TextoPlatoCargado.z_index = 1
		
	elif direccion_x < 0:
		$AnimatedSprite2D.play("Izquierda")
		$AnimatedSprite2D.scale = Vector2(1.0, 1.0)
		$PlatoCargado.z_index = 1
		$TextoPlatoCargado.z_index = 1
		
	else:
		$AnimatedSprite2D.play("Quieto")
		$AnimatedSprite2D.scale = Vector2(1.0, 1.0)
		$PlatoCargado.position = Vector2(0, -38)
		$PlatoCargado.z_index = 1
		$TextoPlatoCargado.z_index = 1

func recibir_dano():
	# Si es inmune, ignoramos el golpe
	if esta_inmune:
		return
		
	vidas -= 1
	print("Me golpearon. Vidas restantes: ", vidas)
	
	# =========================================================
	# PERDER LA COMIDA (-$10 Pesos)
	# =========================================================
	perder_comida()
	
	numero_plato_actual = 0 # El mesero vuelve a tener 0 platos
	
	if has_node("PlatoCargado"):
		$PlatoCargado.texture = null # Borramos la foto de los tacos/hamburguesa
		
	if has_node("TextoPlatoCargado"):
		$TextoPlatoCargado.text = "" # Borramos el número de la mesa
	# =========================================================
	
	# Le avisamos a los corazones que cambien
	if has_node("/root/NodoCalle/CanvasLayer"):
		get_node("/root/NodoCalle/CanvasLayer").actualizar_corazones(vidas)
	
	# Si se acaban las vidas, salimos para que el HUD se encargue de pausar
	if vidas <= 0:
		return
		
	# Regresar al punto inicial si aún le quedan vidas
	position = posicion_inicial
	comenzar_inmunidad()

# =========================================================
# LÓGICA DE DINERO, PROPINAS Y PENALIZACIÓN
# =========================================================

# Llama a esta función cuando entregues un plato con éxito a la mesa
func entregar_plato():
	var propina = calcular_propina_realista()
	dinero_total += propina
	actualizar_interfaz_dinero()
	print("¡Plato entregado! Propina: $", propina, " | Total: $", dinero_total)

func perder_comida():
	dinero_total -= 10
	if dinero_total < 0:
		dinero_total = 0 # Evitamos saldos negativos
	actualizar_interfaz_dinero()
	print("¡Comida tirada! Te descontaron: $10 | Total: $", dinero_total)

func calcular_propina_realista() -> int:
	var numero_azar = randf() * 100.0
	if numero_azar < 50.0:
		return 5       # 50% probabilidad
	elif numero_azar < 92.0:
		return 10      # 42% probabilidad
	else:
		return 30      # 8% probabilidad rara ($30 pesotes)

func actualizar_interfaz_dinero():
	if label_dinero:
		label_dinero.text = "Dinero: $" + str(dinero_total)

# =========================================================

func comenzar_inmunidad():
	esta_inmune = true
	
	# Un ciclo para que parpadee
	for i in range(10):
		$AnimatedSprite2D.modulate.a = 0.2
		await get_tree().create_timer(0.15).timeout
		$AnimatedSprite2D.modulate.a = 1.0
		await get_tree().create_timer(0.15).timeout
		
	esta_inmune = false
