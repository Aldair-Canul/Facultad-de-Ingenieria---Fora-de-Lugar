extends Label

func _ready() -> void:
	visible_characters = 0
	var tween = create_tween()
	tween.tween_property(self, "visible_characters", text.length(), 6.0)
	await tween.finished

	# Fade out (desaparece suavemente en 1 segundo)
	var tween_out = create_tween()
	tween_out.tween_property(self, "modulate:a", 0.0, 3.0)
	await tween_out.finished
