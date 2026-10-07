extends Area2D

var jugador_dentro: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Mesero" or body.name.begins_with("Mesero") or body.is_in_group("jugador"):
		jugador_dentro = true
		print("--> [PORTAL] Jugador listo para entrar al Supermercado. Presiona la tecla de interactuar.")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Mesero" or body.name.begins_with("Mesero") or body.is_in_group("jugador"):
		jugador_dentro = false
		print("--> [PORTAL] Jugador se alejó del portal.")

func _unhandled_input(_event: InputEvent) -> void:
	# Acepta tanto la acción 'Interactuar' como 'ui_accept' (Enter/Espacio)
	if Input.is_action_just_pressed("Interactuar") or Input.is_action_just_pressed("ui_accept"):
		if jugador_dentro:
			print("Cambiando a la escena del Supermercado...")
			var error = get_tree().change_scene_to_file("res://Scenes/Escena_mercado/super compra.tscn")
			if error != OK:
				print("Error al cargar la escena. Revisa la ruta de 'super compra.tscn'")
