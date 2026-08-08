extends CharacterBody2D

# Velocidad a la que se moverá tu personaje
var velocidad = 300

# Referencia a tu nodo de animaciones
@onready var animacion = $AnimatedSprite2D

func _physics_process(_delta):
	# Empezamos asumiendo que el personaje no se mueve
	var direccion = Vector2.ZERO

	# Detectar las teclas (usamos las flechas del teclado por defecto)
	if Input.is_action_pressed("ui_right"):
		direccion.x += 1
		animacion.play("caminar_lado")
		animacion.flip_h = false # NO voltear (mira a la derecha)
		
	elif Input.is_action_pressed("ui_left"):
		direccion.x -= 1
		animacion.play("caminar_lado")
		animacion.flip_h = true # SÍ voltear (mira a la izquierda como espejo)
		
	elif Input.is_action_pressed("ui_down"):
		direccion.y += 1
		animacion.play("caminar_abajo")
		
	elif Input.is_action_pressed("ui_up"):
		direccion.y -= 1
		animacion.play("caminar_arriba")
		
	else:
		# Si no presionamos nada, se queda en reposo
		animacion.play("reposo")

	# Aplicar el movimiento
	# Normalizamos para que no camine más rápido en diagonal
	if direccion != Vector2.ZERO:
		direccion = direccion.normalized()
		
	velocity = direccion * velocidad
	move_and_slide()


func _on_reloj_timeout() -> void:
	pass # Replace with function body.
