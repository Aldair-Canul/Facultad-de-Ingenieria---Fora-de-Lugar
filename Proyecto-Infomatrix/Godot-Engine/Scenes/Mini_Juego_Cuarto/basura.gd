extends Area2D

signal basura_recogida

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		emit_signal("basura_recogida")
		queue_free() # Desaparece de la escena
