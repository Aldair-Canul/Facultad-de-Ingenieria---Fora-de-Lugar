extends Area2D

@export var ruta_cinematica: String = "res://Scenes/Escena_mercado/control.tscn"
@export var tiempo_espera: float = 2.0
@export var label_diner: Label

@onready var sonido_pago: AudioStreamPlayer = get_node_or_null("SonidoPago")

var jugador_dentro: bool = false
var procesando_pago: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Mesero" or body.name.begins_with("Mesero") or body.is_in_group("jugador"):
		jugador_dentro = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Mesero" or body.name.begins_with("Mesero") or body.is_in_group("jugador"):
		jugador_dentro = false

func _unhandled_input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed("Interactuar") or Input.is_action_just_pressed("ui_accept")) and not procesando_pago:
		if jugador_dentro:
			if not DatosJugador.compra_lista:
				print("Cajera: 'Aún no completas los 10 productos de tu lista por $500.'")
				return
			
			var exito = DatosJugador.pagar_compra()
			if exito:
				procesando_pago = true
				
				if sonido_pago:
					sonido_pago.play()
				
				_animar_descuento(500)
				
				await get_tree().create_timer(tiempo_espera).timeout
				
				# Carga la escena donde se reproduce tu video cinemático
				if has_node("/root/TransitionLayer"):
					TransitionLayer.change_scene(ruta_cinematica)
				else:
					get_tree().change_scene_to_file(ruta_cinematica)

func _animar_descuento(monto: int) -> void:
	var target = label_diner
	if not target:
		target = get_tree().current_scene.find_child("LabelDiner", true, false) as Label
		if not target:
			target = get_tree().current_scene.find_child("LabelDinero", true, false) as Label

	if not target:
		return

	target.text = "Dinero: $" + str(DatosJugador.dinero)

	var flotante: Label = target.duplicate() as Label
	target.get_parent().add_child(flotante)
	flotante.text = "-$" + str(monto)
	flotante.modulate = Color(1.0, 0.25, 0.25, 1.0)
	flotante.global_position = target.global_position + Vector2(0, 15)

	var pos_inicial_y: float = flotante.position.y
	var tween = create_tween().set_parallel(true)
	tween.tween_property(flotante, "position:y", pos_inicial_y + 35, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(flotante, "modulate:a", 0.0, 1.2)
	
	await tween.finished
	flotante.queue_free()
