extends StaticBody2D

@export var numero_de_esta_mesa = 1

func _ready():
	$ZonaEntrega.body_entered.connect(_on_zona_entrega_body_entered)
	$TextoNumero.text = str(numero_de_esta_mesa)

func _on_zona_entrega_body_entered(body):
	if body.name == "Mesero":
		if body.numero_plato_actual == numero_de_esta_mesa:
			var reproductor_audio = get_node_or_null("%Sonidocampana")
			if reproductor_audio:
				reproductor_audio.play()
			
			if body.has_method("entregar_plato"):
				body.entregar_plato()
			
			body.numero_plato_actual = 0
			body.get_node("PlatoCargado").texture = null
			
			var escena_calle = get_tree().current_scene
			if escena_calle.has_method("registrar_platillo_entregado"):
				escena_calle.registrar_platillo_entregado()
