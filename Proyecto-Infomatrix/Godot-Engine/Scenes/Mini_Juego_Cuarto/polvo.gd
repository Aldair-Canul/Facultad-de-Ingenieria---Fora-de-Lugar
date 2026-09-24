extends Area2D

@export var tiempo_para_limpiar: float = 1.2 # Segundos necesarios para limpiar esta pila
var tiempo_barrido: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("polvo") # Nombre de la animación de tu hoja de sprites

func _process(delta: float) -> void:
	# Detectar si el Player está encima del área
	for body in get_overlapping_bodies():
		if body.name == "Player" or body.is_in_group("player"):
			# Si el jugador está barriendo (presionando 'A')
			if Input.is_key_pressed(KEY_A):
				tiempo_barrido += delta
				
				# Desvanecer gradualmente la transparencia (alfa) del polvo mientras se barre
				modulate.a = 1.0 - (tiempo_barrido / tiempo_para_limpiar)
				
				# Al completar el tiempo, destruir la pila de polvo
				if tiempo_barrido >= tiempo_para_limpiar:
					queue_free()
			break
