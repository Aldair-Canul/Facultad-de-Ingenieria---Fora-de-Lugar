extends CharacterBody2D

@export var VELOCIDAD = 200.0
var numero_plato_actual = 0
var vidas = 3
var posicion_inicial: Vector2
var esta_inmune = false

var dinero_total: int = 0
var label_dinero: Label

func _ready():
	posicion_inicial = position
	label_dinero = get_tree().current_scene.get_node_or_null("CanvasLayer/LabelDinero")
	actualizar_interfaz_dinero()

func _physics_process(_delta):
	var direccion_x = 0
	var direccion_y = 0

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
	
	velocity.x = direccion_x * VELOCIDAD
	velocity.y = direccion_y * VELOCIDAD
	
	move_and_slide()
	position.x = clamp(position.x, 40, 960)
	position.y = clamp(position.y, 230, 575)
	
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
		$PlatoCargado.z_index = -1
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
	if esta_inmune:
		return
		
	vidas -= 1
	perder_comida()
	numero_plato_actual = 0
	
	if has_node("PlatoCargado"):
		$PlatoCargado.texture = null
	if has_node("TextoPlatoCargado"):
		$TextoPlatoCargado.text = ""
	
	if has_node("/root/NodoCalle/CanvasLayer"):
		get_node("/root/NodoCalle/CanvasLayer").actualizar_corazones(vidas)
	
	if vidas <= 0:
		return
		
	position = posicion_inicial
	comenzar_inmunidad()

func entregar_plato():
	var propina = calcular_propina_realista()
	dinero_total += propina
	actualizar_interfaz_dinero()

func perder_comida():
	dinero_total -= 10
	if dinero_total < 0:
		dinero_total = 0
	actualizar_interfaz_dinero()

func calcular_propina_realista() -> int:
	var numero_azar = randf() * 100.0
	if numero_azar < 50.0:
		return 5
	elif numero_azar < 92.0:
		return 10
	else:
		return 30

func actualizar_interfaz_dinero():
	if label_dinero:
		label_dinero.text = "Dinero: $" + str(dinero_total)

func comenzar_inmunidad():
	esta_inmune = true
	for i in range(10):
		$AnimatedSprite2D.modulate.a = 0.2
		await get_tree().create_timer(0.15).timeout
		$AnimatedSprite2D.modulate.a = 1.0
		await get_tree().create_timer(0.15).timeout
	esta_inmune = false
