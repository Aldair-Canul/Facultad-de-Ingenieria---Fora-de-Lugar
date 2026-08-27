extends Area2D

@export var velocidad = 150.0


@export var limite_izquierdo = 20.0
@export var limite_derecho = 980.0
@export var limite_superior = 250.0  
@export var limite_inferior = 600.0  

var direccion = Vector2.ZERO

var tiempo_para_acelerar = 0.0
var tiempo_para_cambiar_rumbo = 0.0
var tiempo_siguiente_cambio = 2.0

func _ready():
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	elegir_direccion_aleatoria()

func _process(delta):
	# aceleracion variable 
	tiempo_para_acelerar += delta
	if tiempo_para_acelerar > 1.5:
		velocidad = randf_range(120, 300)
		tiempo_para_acelerar = 0.0


	tiempo_para_cambiar_rumbo += delta
	if tiempo_para_cambiar_rumbo >= tiempo_siguiente_cambio:
		elegir_direccion_aleatoria()

	
	position += direccion * velocidad * delta

	#  Validar bordes de la calle
	comprobar_limites()

func elegir_direccion_aleatoria():
	tiempo_para_cambiar_rumbo = 0.0
	tiempo_siguiente_cambio = randf_range(1.5, 3.5)
	
	var opciones = []
	
	# Si actualmente se mueve en vertical, forzamos que elija mover horizontal (para que varíe)
	if direccion.x == 0 and direccion.y != 0:
		opciones = [Vector2(1, 0), Vector2(-1, 0)] # Izquierda o Derecha
	# Si está en horizontal, permitimos que elija ir en vertical
	else:
		opciones = [Vector2(0, 1), Vector2(0, -1)] # Abajo o Arriba
	
	direccion = opciones[randi() % opciones.size()]
	aplicar_animacion_escala_y_colision()

func comprobar_limites():
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

func aplicar_animacion_escala_y_colision():
	if direccion == Vector2(0, 1): # ABAJO
		$AnimatedSprite2D.play("abajo")
		# Si se ve pequeño, aumentamos la medida objetivo (ej. 110px)
		ajustar_tamano_proporcional(110.0, true) 
		$CollisionShape2D.shape.size = Vector2(30, 55)
		
	elif direccion == Vector2(0, -1): # ARRIBA
		$AnimatedSprite2D.play("arriba")
		# Usamos la misma medida que "abajo" para que sean simétricos
		ajustar_tamano_proporcional(110.0, true) 
		$CollisionShape2D.shape.size = Vector2(30, 55)
		
	elif direccion == Vector2(1, 0): # DERECHA
		$AnimatedSprite2D.play("derecha")
		ajustar_tamano_proporcional(64.0, false) # Mantenemos 64px para los lados
		$CollisionShape2D.shape.size = Vector2(52, 28)
		
	elif direccion == Vector2(-1, 0): # IZQUIERDA
		$AnimatedSprite2D.play("izquierda")
		ajustar_tamano_proporcional(64.0, false) 
		$CollisionShape2D.shape.size = Vector2(52, 28)
		
func ajustar_tamano_proporcional(medida_objetivo: float, es_vertical: bool):
	var sprite = $AnimatedSprite2D
	var textura = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	
	if textura:
		var tamano_original = textura.get_size()
		var factor_escala = 1.0
		
		# Calculamos el factor de escala basándonos en un solo eje para no aplastar la imagen
		if es_vertical:
			factor_escala = medida_objetivo / tamano_original.y
		else:
			factor_escala = medida_objetivo / tamano_original.x
			
		# Aplicamos el mismo factor a ambos ejes (mantiene la forma original sin deformar)
		sprite.scale = Vector2(factor_escala, factor_escala)
func ajustar_tamano_sprite_exacto(tamano_deseado: Vector2):
	var sprite = $AnimatedSprite2D
	# Obtenemos la textura del fotograma actual de la animación
	var textura = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	
	if textura:
		var tamano_original = textura.get_size()
		# Calculamos la escala exacta dividiendo el tamaño deseado entre el original
		sprite.scale = tamano_deseado / tamano_original
func _on_body_entered(body: Node2D) -> void:
	# Si choca con el mesero, hace daño
	if body.has_method("recibir_dano"):
		body.recibir_dano()
	# Si choca contra una mesa u obstáculo, reacciona dando la vuelta
	else:
		elegir_direccion_aleatoria()

# Si tus mesas usan Area2D en lugar de cuerpos físicos, conecta también la señal area_entered:
func _on_area_entered(area: Area2D) -> void:
	if area != self and not area.has_method("recibir_dano"):
		elegir_direccion_aleatoria()
