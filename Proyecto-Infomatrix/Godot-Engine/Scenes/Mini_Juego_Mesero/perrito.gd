extends Area2D

@export var velocidad = 100
@export var limite_izquierdo = 100
@export var limite_derecho = 500

var direccion = 1 # 1 es derecha, -1 es izquierda

func _process(delta):
	# Movemos al perrito en el eje X
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
