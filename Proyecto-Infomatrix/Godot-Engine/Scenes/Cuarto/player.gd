extends CharacterBody2D

const SPEED = 200.0
@onready var anim = $AnimatedSprite2D

# --- Variables de la fórmula de tu profe ---
var E_max: float = 0.75   # Tamaño al frente (frente al inodoro)
var E_min: float = 0.55   # Tamaño al fondo (junto a la pared)

# Puedes ajustar estos números directamente en el Inspector de Godot
@export var y_suelo: float = 500.0   # Posición Y (en píxeles) del piso / zona más baja
@export var y_tope: float = 200.0    # Posición Y (en píxeles) de la parte más alta

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
	
	# 4. Aplicar escala según la fórmula del profe
	aplicar_escala_profe()
	
	# 5. Actualizar las animaciones
	actualizar_animaciones(direction)

func aplicar_escala_profe():
	# Calculamos h_max (distancia entre piso y tope)
	var h_max = y_suelo - y_tope
	
	# Calculamos h (altura que ha subido desde el piso)
	var h = y_suelo - global_position.y
	
	# Limitamos h entre 0 y h_max
	h = clamp(h, 0.0, h_max)
	
	# Pendiente m = (E_min - 1) / h_max
	var m = (E_min - E_max) / h_max
	
	# E = m * h + 1 (Fórmula exacta de la hoja)
	var E = (m * h) + E_max
	
	# Aplicamos la escala al personaje
	scale = Vector2(E, E)

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
