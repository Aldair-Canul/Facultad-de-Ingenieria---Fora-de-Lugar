extends Node2D

# Variable para saber si ya ocultamos el texto
var tutorial_oculto: bool = false

# Variables para el control de los muebles
var muebles_colocados: int = 0
const TOTAL_MUEBLES: int = 3

func _input(event: InputEvent) -> void:
	# Verificamos si el tutorial sigue visible y si el evento es un botón del mouse
	if not tutorial_oculto and event is InputEventMouseButton:
		# Verificamos que sea un clic izquierdo y que esté presionado
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
			var texto_tutorial = $CanvasLayer/PanelContainer 
			
			if texto_tutorial != null:
				texto_tutorial.hide()
				tutorial_oculto = true # Marcamos que ya se ocultó

# Llama a esta función cada vez que un mueble encaje correctamente en su silueta
func registrar_mueble_colocado() -> void:
	muebles_colocados += 1
	
	# Opcional: reproducir el sonido de clic al encajar un mueble
	if $SonidoClick:
		$SonidoClick.play()
	
	# Si ya acomodó Cama, Silla y Mesa
	if muebles_colocados >= TOTAL_MUEBLES:
		_finalizar_minijuego()

func _finalizar_minijuego() -> void:
	# Pausa de 0.8s para que el jugador aprecie el último mueble encajado
	await get_tree().create_timer(0.8).timeout
	
	# Cambiar a la escena con la animación del parpadeo
	get_tree().change_scene_to_file("res://Scenes/Mini_Juego_Cuarto/PantallaDormir.tscn")
