extends StaticBody2D

# Esta variable la podremos cambiar desde el editor para cada mesa diferente
@export var numero_de_esta_mesa = 1 

func _ready():
	# Conectamos la señal para saber cuándo entra un cuerpo a la zona de entrega
	$ZonaEntrega.body_entered.connect(_on_zona_entrega_body_entered)
	$TextoNumero.text = str(numero_de_esta_mesa)

func _on_zona_entrega_body_entered(body):
	# Comprobamos si el cuerpo que entró es el Mesero
	if body.name == "Mesero":
		# Comprobamos si el número de plato que carga coincide con ESTA mesa
		if body.numero_plato_actual == numero_de_esta_mesa:
			
			# --- NUEVA LÓGICA DE AUDIO ---
			# Buscamos el nodo de sonido único en la escena usando su nombre tal cual aparece en tu editor
			var reproductor_audio = get_node_or_null("%Sonidocampana")
			
			# Si encuentra el nodo, reproduce la campanita 🎵
			if reproductor_audio:
				reproductor_audio.play()
			# ------------------------------
			
			# 1. Dejamos las manos del mesero vacías de nuevo
			body.numero_plato_actual = 0
			
			# 2. Borramos la textura de la comida de sus manos
			body.get_node("PlatoCargado").texture = null
			
			# 3. Imprimimos en la consola para confirmar que funcionó
			print("¡Plato entregado con éxito en la Mesa ", numero_de_esta_mesa, "!")
