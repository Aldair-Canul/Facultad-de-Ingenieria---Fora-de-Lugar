extends CharacterBody2D

@export var speed: float = 200.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	# 1. Obtener dirección del movimiento (WASD / Flechas)
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	move_and_slide()
	
	# 2. Actualizar animaciones
	actualizar_animacion(input_dir)

func actualizar_animacion(input_dir: Vector2) -> void:
	# PRIORIDAD 1: Barrer
	if Input.is_key_pressed(KEY_A):
		sprite.flip_h = false
		if sprite.animation != "barrer":
			sprite.play("barrer")
			$Barriendo.play()
			
		return

	# PRIORIDAD 2: Movimiento horizontal (Izquierda / Derecha)
	if input_dir.x != 0:
		sprite.play("caminar_lado")
		sprite.flip_h = input_dir.x < 0
		$Barriendo.stop()
	# Movimiento vertical (Abajo / Arriba)
	elif input_dir.y > 0:
		sprite.flip_h = false
		sprite.play("caminar_adelante")
		$Barriendo.stop()
	elif input_dir.y < 0:
		sprite.flip_h = false
		sprite.play("caminar_atras")
		$Barriendo.stop()
	# PRIORIDAD 3: Reposo (Idle)
	else:
		sprite.flip_h = false
		sprite.play("idle")
		$Barriendo.stop()
