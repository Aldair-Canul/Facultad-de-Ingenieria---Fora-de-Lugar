extends CharacterBody2D

@export var VELOCIDAD = 200.0
var numero_plato_actual = 0  # 0 significa manos vacías
var vidas = 3
var posicion_inicial: Vector2
var esta_inmune = false

func _ready():
	# Guardamos la posición donde inicia el mesero al empezar el juego
	posicion_inicial = position
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
		# -------------------------------------------------------------
		# CORREGIDO: Reducimos a la mitad (0.5) porque el sprite base es muy grande.
		# Si notas que queda muy chico o muy grande, calíbralo a 0.55 o 0.6
		# -------------------------------------------------------------
		$AnimatedSprite2D.scale = Vector2(0.9, 0.9)
		
		$PlatoCargado.position = Vector2(0, -38)
		$PlatoCargado.z_index = 1
		$TextoPlatoCargado.z_index = 1
		
	elif direccion_y < 0:
		$AnimatedSprite2D.play("Arriba")
		# Reducimos también a la mitad cuando va hacia atrás
		$AnimatedSprite2D.scale = Vector2(0.9, 0.9) 
		
		$PlatoCargado.position = Vector2(0, -50)
		$PlatoCargado.z_index = -1  # Esconde el plato tras la espalda
		$TextoPlatoCargado.z_index = -1
		
	elif direccion_x > 0:
		$AnimatedSprite2D.play("Derecha")
		$AnimatedSprite2D.scale = Vector2(1.0, 1.0) # Vuelve al tamaño original (100%)
		$PlatoCargado.z_index = 1
		$TextoPlatoCargado.z_index = 1
		
	elif direccion_x < 0:
		$AnimatedSprite2D.play("Izquierda")
		$AnimatedSprite2D.scale = Vector2(1.0, 1.0) # Vuelve al tamaño original (100%)
		$PlatoCargado.z_index = 1
		$TextoPlatoCargado.z_index = 1
		
	else:
		$AnimatedSprite2D.play("Quieto")
		$AnimatedSprite2D.scale = Vector2(1.0, 1.0) # Vuelve al tamaño original (100%)
		$PlatoCargado.position = Vector2(0, -38)
		$PlatoCargado.z_index = 1
		$TextoPlatoCargado.z_index = 1

func recibir_dano():
	# Si es inmune, ignoramos el golpe
	if esta_inmune:
		return
		
	vidas -= 1
	print("Me golpearon. Vidas restantes: ", vidas)
	
	# Dinámica de soltar la comida en la colisión
	numero_plato_actual = 0
	if has_node("PlatoCargado"):
		$PlatoCargado.visible = false
	if has_node("TextoPlatoCargado"):
		$TextoPlatoCargado.visible = false
	
	# Le avisamos a los corazones que cambien
	if has_node("/root/NodoCalle/CanvasLayer"):
		get_node("/root/NodoCalle/CanvasLayer").actualizar_corazones(vidas)
	
	# Si se acaban las vidas, salimos para que el HUD se encargue de pausar
	if vidas <= 0:
		return
		
	# Regresar al punto inicial si aún le quedan vidas
	position = posicion_inicial
	comenzar_inmunidad()

func comenzar_inmunidad():
	esta_inmune = true
	
	# Un ciclo para que parpadee: 10 veces (0.15s invisible + 0.15s visible = 0.3s por ciclo x 10 = 3 segundos)
	for i in range(10):
		$AnimatedSprite2D.modulate.a = 0.2 # Se vuelve casi transparente
		await get_tree().create_timer(0.15).timeout
		$AnimatedSprite2D.modulate.a = 1.0 # Vuelve a la normalidad
		await get_tree().create_timer(0.15).timeout
		
	esta_inmune = false
