extends Area2D

@export var ruta_cinematica: String = "res://Scenes/Escena_mercado/control.tscn"
@export var tiempo_espera: float = 2.0 # Segundos que esperará antes de cambiar a la cinemática
@export var label_diner: Label # Asignado desde el Inspector o buscado automáticamente

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
@onready var sonido_pago: AudioStreamPlayer = get_node_or_null("SonidoPago")

var jugador_dentro: bool = false
var procesando_pago: bool = false # Evita presionar enter varias veces seguidas

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Asegurarnos de que el Label principal esté visible y con el texto "Dinero:"
	var target = _obtener_label_diner()
	if target:
		target.visible = true
		_actualizar_texto_saldo(target)
		
	if animacion:
		animacion.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Mesero" or body.name.begins_with("Mesero") or body.is_in_group("jugador"):
		jugador_dentro = true
		
		if not DatosJugador.compra_lista:
			print("Cajera: 'Hola. Ve al portal del supermercado para seleccionar tus productos primero.'")
		else:
			var total = DatosJugador.obtener_total_a_pagar()
			print("Cajera: 'Tu total es de $", total, ". Presiona Interactuar o Enter para pagar.'")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Mesero" or body.name.begins_with("Mesero") or body.is_in_group("jugador"):
		jugador_dentro = false

func _unhandled_input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("Interactuar") or Input.is_action_just_pressed("ui_accept")) and not procesando_pago:
		if jugador_dentro:
			if not DatosJugador.compra_lista:
				print("Cajera: 'No tienes ninguna compra pendiente por pagar.'")
				return
			
			var total = DatosJugador.obtener_total_a_pagar()
			var exito = DatosJugador.pagar_compra()
			
			if exito:
				procesando_pago = true
				print("¡Pago realizado! El dinero se ha descontado.")
				
				# 1. Reproducir sonido
				if sonido_pago:
					sonido_pago.play()
			
				_animar_descuento(total)
				
				
				await get_tree().create_timer(tiempo_espera).timeout
				
				print("Cargando cinemática...")
				if has_node("/root/TransitionLayer"):
					TransitionLayer.change_scene(ruta_cinematica)
				else:
					get_tree().change_scene_to_file(ruta_cinematica)
			else:
				print("Cajera: 'No tienes suficiente dinero para pagar esta compra.'")

# --- FUNCIÓN DE BÚSQUEDA DEL NODO ---
func _obtener_label_diner() -> Label:
	if label_diner:
		return label_diner
		
	if get_tree() and get_tree().current_scene:
		var nodo_encontrado = get_tree().current_scene.find_child("LabelDiner", true, false)
		if not nodo_encontrado:
			nodo_encontrado = get_tree().current_scene.find_child("LabelDinero", true, false)
			
		if nodo_encontrado is Label:
			label_diner = nodo_encontrado
			return label_diner
			
	return null

# --- ACTUALIZA EL TEXTO MANTENIENDO EL "dinero:"
func _actualizar_texto_saldo(target: Label) -> void:
	var cantidad: int = 0
	if "dinero" in DatosJugador:
		cantidad = DatosJugador.dinero
	elif DatosJugador.has_method("obtener_dinero"):
		cantidad = DatosJugador.obtener_dinero()
		
	target.text = "Dinero: $" + str(cantidad)

# --- ANIMACIÓN DE DESCUENTO ---
func _animar_descuento(monto: int) -> void:
	var target_original = _obtener_label_diner()
	if not target_original:
		print("Advertencia: No se encontró el nodo LabelDiner")
		return


	_actualizar_texto_saldo(target_original)
	target_original.visible = true
	target_original.modulate.a = 1.0


	var flotante: Label = target_original.duplicate() as Label
	target_original.get_parent().add_child(flotante)


	flotante.text = "-$" + str(monto)
	flotante.modulate = Color(1.0, 0.25, 0.25, 1.0) # Rojo brillante
	flotante.global_position = target_original.global_position + Vector2(0, 15)
	flotante.visible = true


	var pos_inicial_y: float = flotante.position.y
	var tween = create_tween().set_parallel(true)
	tween.tween_property(flotante, "position:y", pos_inicial_y + 35, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(flotante, "modulate:a", 0.0, 1.5)

	# 5. Eliminar el clon de la memoria
	await tween.finished
	flotante.queue_free()
