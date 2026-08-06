extends Node2D

# Variable para saber si ya ocultamos el texto
var tutorial_oculto = false

func _input(event):
	# Verificamos si el tutorial sigue visible y si el evento es un botón del mouse
	if not tutorial_oculto and event is InputEventMouseButton:
		# Verificamos que sea un clic izquierdo y que esté presionado
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
			# Buscamos tu nodo de texto en el CanvasLayer
			# (Recuerda cambiar "PanelContainer" por el nombre exacto de tu nodo)
			var texto_tutorial = $CanvasLayer/PanelContainer 
			
			if texto_tutorial != null:
				texto_tutorial.hide()
				tutorial_oculto = true # Marcamos que ya se ocultó
