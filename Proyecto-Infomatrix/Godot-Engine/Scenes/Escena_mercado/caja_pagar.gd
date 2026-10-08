extends Area2D

@export var ruta_cinematica: String = "res://Scenes/Escena_mercado/control.tscn"
@export var tiempo_espera: float = 2.0 # Segundos que esperará antes de cambiar a la cinemática

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D

var jugador_dentro: bool = false
var procesando_pago: bool = false # Evita presionar enter varias veces seguidas

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
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
			
			var exito = DatosJugador.pagar_compra()
			if exito:
				procesando_pago = true
				print("¡Pago realizado! El dinero se ha descontado.")
				
				# Espera el tiempo especificado (ej. 2 segundos)
				await get_tree().create_timer(tiempo_espera).timeout
				
				print("Cargando cinemática...")
				
				# --- CAMBIO AQUÍ: Usamos la función personalizada de TransitionLayer ---
				if has_node("/root/TransitionLayer"):
					TransitionLayer.change_scene(ruta_cinematica)
				else:
					get_tree().change_scene_to_file(ruta_cinematica)
			else:
				print("Cajera: 'No tienes suficiente dinero para pagar esta compra.'")
