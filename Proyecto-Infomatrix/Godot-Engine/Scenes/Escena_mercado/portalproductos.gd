extends Area2D

var jugador_dentro: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	print("Objeto detectado en el portal: ", body.name)
	if body.name == "Mesero" or body.name.begins_with("Mesero") or body.is_in_group("jugador"):
		jugador_dentro = true
		print("--> ¡Jugador detectado dentro del portal!")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Mesero" or body.name.begins_with("Mesero") or body.is_in_group("jugador"):
		jugador_dentro = false
		print("--> Jugador salió del portal")

func _unhandled_input(_event: InputEvent) -> void:
	# Corregido: "Interactuar" con I mayúscula como está en tu Mapa de Entradas
	if Input.is_action_just_pressed("Interactuar"):
		print("Se presionó 'Interactuar'. ¿El jugador está dentro?: ", jugador_dentro)
		if jugador_dentro:
			print("Intentando cambiar a la escena...")
			var error = get_tree().change_scene_to_file("res://Scenes/Escena_mercado/super compra.tscn")
			if error != OK:
				print("Error al cargar la ruta. Verifica si el archivo existe o la ruta es correcta.")
