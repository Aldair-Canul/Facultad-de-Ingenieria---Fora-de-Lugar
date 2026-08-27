extends CharacterBody2D

const SPEED = 200.0
@onready var anim = $AnimatedSprite2D

func _physics_process(_delta):
	# 1. Obtener la dirección de entrada
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	# 2. Normalizar la velocidad para que no corra más rápido en diagonal
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	# 3. Mover al personaje
	move_and_slide()
	
	# 4. Actualizar las animaciones
	actualizar_animaciones(direction)

func actualizar_animaciones(dir: Vector2):
	if dir.x != 0:
		anim.play("walk_side")
		# Voltea el sprite si camina hacia la izquierda
		anim.flip_h = dir.x < 0 
	elif dir.y > 0:
		anim.play("walk_down")
	elif dir.y < 0:
		anim.play("walk_up")
	else:
		anim.play("idle")
