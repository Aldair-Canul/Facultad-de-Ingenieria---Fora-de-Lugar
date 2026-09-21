extends CharacterBody2D

@export var speed: float = 200.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
	actualizar_animacion(direction)

func actualizar_animacion(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		sprite.play("reposo")
		sprite.scale = Vector2(0.3, 0.3) # Ajusta este valor según el tamaño que necesites
		return

	sprite.scale = Vector2(0.2,0.2) # Restablece la escala original

	if direction.x != 0:
		sprite.play("izquierda")
		if direction.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	elif direction.y < 0:
		sprite.play("arriba")
		sprite.flip_h = false
	elif direction.y > 0:
		sprite.play("abajo")
		sprite.flip_h = false
