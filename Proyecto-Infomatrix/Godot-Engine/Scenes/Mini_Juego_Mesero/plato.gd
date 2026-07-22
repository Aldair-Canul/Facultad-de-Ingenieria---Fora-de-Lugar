extends Area2D

# Variable que guardará a qué mesa debe ir este plato (del 1 al 6)
var numero_mesa_destino = 1 

func _ready():
	# Conectamos la detección: cuando un cuerpo entra al área
	body_entered.connect(_on_body_entered)

# Esta función la llamará la calle para configurarlo al nacer
func configurar_plato(numero_mesa, imagen_comida):
	numero_mesa_destino = numero_mesa
	$Sprite2D.texture = imagen_comida
	
	# ====================================================================
	# NUEVO: Mostramos el número de mesa en el texto flotante del plato
	# str() convierte el número en texto para que el Label lo pueda leer
	# ====================================================================
	$TextoMesa.text = str(numero_mesa)

func _on_body_entered(body):
	# Verificamos si el que lo pisó es el Mesero
	if body.name == "Mesero":
		if body.numero_plato_actual == 0:
			body.numero_plato_actual = numero_mesa_destino
			body.get_node("PlatoCargado").texture = $Sprite2D.texture
			body.get_node("PlatoCargado").visible = true # Por si acaso
			body.get_node("TextoPlatoCargado").text = str(numero_mesa_destino)
			body.get_node("TextoPlatoCargado").visible = true
			queue_free()
