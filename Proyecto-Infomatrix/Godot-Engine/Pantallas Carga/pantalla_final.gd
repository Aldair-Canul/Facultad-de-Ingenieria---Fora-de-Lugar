extends Control

@onready var boton_salir: Button = $Button

func _ready() -> void:
	boton_salir.pressed.connect(_on_salir_pressed)

func _on_salir_pressed() -> void:
	# 1. Desactivar botón para evitar clics dobles
	boton_salir.disabled = true
	
	var tamano_pantalla := get_viewport_rect().size
	var mitad_altura := tamano_pantalla.y / 2.0
	
	# 2. Crear Párpado Superior (inicia oculto arriba)
	var parpado_arriba := ColorRect.new()
	parpado_arriba.color = Color.BLACK
	parpado_arriba.size = Vector2(tamano_pantalla.x, mitad_altura)
	parpado_arriba.position = Vector2(0, -mitad_altura)
	add_child(parpado_arriba)
	
	# 3. Crear Párpado Inferior (inicia oculto abajo)
	var parpado_abajo := ColorRect.new()
	parpado_abajo.color = Color.BLACK
	parpado_abajo.size = Vector2(tamano_pantalla.x, mitad_altura)
	parpado_abajo.position = Vector2(0, tamano_pantalla.y)
	add_child(parpado_abajo)
	
	# 4. Animar ambos párpados cerrándose hacia el centro al mismo tiempo
	var tween := create_tween().set_parallel(true)
	
	# Párpado de arriba baja al centro
	tween.tween_property(parpado_arriba, "position:y", 0.0, 0.5) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
		
	# Párpado de abajo sube al centro
	tween.tween_property(parpado_abajo, "position:y", mitad_altura, 0.5) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	
	# 5. Esperar a que el ojo se cierre completamente
	await tween.finished

	# 6. Cerrar el juego o refrescar en web
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.location.reload();")
	else:
		get_tree().quit()

func _on_button_pressed() -> void:
	_on_salir_pressed()
