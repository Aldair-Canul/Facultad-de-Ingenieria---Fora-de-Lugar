extends Area2D

@export var velocidad = 150.0

# --- LÍMITES AJUSTADOS AL SUELO DE PIEDRA ---
@export var limite_izquierdo = 20.0
@export var limite_derecho = 980.0
@export var limite_superior = 280.0  # ¡Aquí está la magia! No subirán a los puestos
@export var limite_inferior = 560.0  # Abajo cerca del borde de la pantalla

var direccion = Vector2.ZERO

# Cronómetros
var tiempo_para_acelerar = 0.0
var tiempo_para_cambiar_rumbo = 0.0
var tiempo_siguiente_cambio = 2.0 # Segundos para elegir otra dirección

func _ready():
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	# Al nacer, elige una dirección al azar inmediatamente
	elegir_direccion_aleatoria()

func _process(delta):
	# 1. Variar velocidad de vez en cuando
	tiempo_para_acelerar += delta
	if tiempo_para_acelerar > 1.5:
		velocidad = randf_range(120, 350)
		tiempo_para_acelerar = 0.0

	# 2. Elegir un camino nuevo al azar cada X segundos
	tiempo_para_cambiar_rumbo += delta
	if tiempo_para_cambiar_rumbo >= tiempo_siguiente_cambio:
		elegir_direccion_aleatoria()

	# 3. Mover al perrito
	position += direccion * velocidad * delta

	# 4. Validar que no se salgan del suelo de piedra
	comprobar_limites()

func elegir_direccion_aleatoria():
	tiempo_para_cambiar_rumbo = 0.0
	tiempo_siguiente_cambio = randf_range(1.5, 4.0) # Tiempo aleatorio antes de cambiar de idea
	
	# Lista de las 4 direcciones posibles
	var opciones = [
		Vector2(0, 1),   # Abajo
		Vector2(0, -1),  # Arriba
		Vector2(1, 0),   # Derecha
		Vector2(-1, 0)   # Izquierda
	]
	
	# Elegir una al azar
	var nueva_dir = opciones[randi() % opciones.size()]
	
	# Evitar que se quede en la misma dirección si queremos que varíe
	direccion = nueva_dir
	aplicar_animacion_y_colision()

func comprobar_limites():
	# Si toca un límite, reacciona dando la vuelta y eligiendo otra ruta
	if position.y <= limite_superior:
		position.y = limite_superior
		elegir_direccion_aleatoria()
	elif position.y >= limite_inferior:
		position.y = limite_inferior
		elegir_direccion_aleatoria()
	elif position.x <= limite_izquierdo:
		position.x = limite_izquierdo
		elegir_direccion_aleatoria()
	elif position.x >= limite_derecho:
		position.x = limite_derecho
		elegir_direccion_aleatoria()

func aplicar_animacion_y_colision():
	if direccion == Vector2(0, 1):
		$AnimatedSprite2D.play("abajo")
		$CollisionShape2D.shape.size = Vector2(25, 45)
	elif direccion == Vector2(0, -1):
		$AnimatedSprite2D.play("arriba")
		$CollisionShape2D.shape.size = Vector2(25, 45)
	elif direccion == Vector2(1, 0):
		$AnimatedSprite2D.play("derecha")
		$CollisionShape2D.shape.size = Vector2(45, 25)
	elif direccion == Vector2(-1, 0):
		$AnimatedSprite2D.play("izquierda")
		$CollisionShape2D.shape.size = Vector2(45, 25)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("recibir_dano"):
		body.recibir_dano()
