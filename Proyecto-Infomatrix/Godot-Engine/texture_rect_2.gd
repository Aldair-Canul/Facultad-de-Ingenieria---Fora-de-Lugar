extends TextureRect

func _ready() -> void:
	# Empieza invisible (opacidad 0)
	modulate.a = 0.0
	visible = true

	# Fade in (aparece suavemente en 1 segundo)
	var tween_in = create_tween()
	tween_in.tween_property(self, "modulate:a", 1.0, 1.0)
	await tween_in.finished

	# Espera 30 segundos visible
	await get_tree().create_timer(7.0).timeout

	# Fade out (desaparece suavemente en 1 segundo)
	var tween_out = create_tween()
	tween_out.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween_out.finished

	# Borra el nodo de la escena
	queue_free()
