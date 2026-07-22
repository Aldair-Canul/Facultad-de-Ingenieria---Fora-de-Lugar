extends Area2D

@export var velocidad = 100
@export var limite_izquierdo = 0
@export var limite_derecho = 1152

var direccion = 1 # 1 es derecha, -1 es izquierda

# Este cronómetro acumula los segundos para saber cuándo cambiar de ritmo
var tiempo_para_acelerar = 0.0

func _process(delta):
	# Sumamos el tiempo que pasa en cada fotograma
	tiempo_para_acelerar += delta
	
	# Cada 1.5 segundos, el perrito decide cambiar su velocidad por sorpresa
	if tiempo_para_acelerar > 1.5:
		# randf_range elige un número al azar entre un trote lento (100) y una carrera rápida (350)
		velocidad = randf_range(150, 500)
		tiempo_para_acelerar = 0.0 # Reiniciamos el cronómetro
	
	# Movemos al perrito en el eje X (usa la velocidad cambiante)
	position.x += velocidad * direccion * delta
	
	# Reproducimos la animación correcta según a dónde va
	if direccion == 1:
		$AnimatedSprite2D.play("derecha")
	else:
		$AnimatedSprite2D.play("izquierda")
	
	# Si llega al límite derecho, cambia de dirección
	if position.x >= limite_derecho:
		direccion = -1
		
	# Si llega al límite izquierdo, cambia de dirección
	elif position.x <= limite_izquierdo:
		direccion = 1


func _on_body_entered(body: Node2D) -> void:
	# Si el objeto que tocamos tiene la función de recibir daño (el mesero), la activamos
	if body.has_method("recibir_dano"):
		body.recibir_dano()
