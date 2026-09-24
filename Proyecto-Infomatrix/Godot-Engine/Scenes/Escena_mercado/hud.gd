extends CanvasLayer

@onready var label_dinero: Label = $ContenedorDinero/LabelDinero
@onready var boton_canasta: TextureButton = $Canasta/BotonCanasta # Cambia a Button si usas un Button normal
@onready var panel_desplegable: PanelContainer = $Canasta/PanelDesplegable
@onready var lista_productos: VBoxContainer = $Canasta/PanelDesplegable/ScrollCanasta/ListaProductos

func _ready() -> void:
	# Conectamos el botón para abrir/cerrar la canasta
	boton_canasta.pressed.connect(_on_boton_canasta_pressed)
	
	# Conectamos señales globales
	DatosJugador.dinero_cambiado.connect(actualizar_dinero)
	DatosJugador.inventario_actualizado.connect(actualizar_canasta)
	
	# Cargamos datos
	actualizar_dinero(DatosJugador.dinero)
	actualizar_canasta()

func _on_boton_canasta_pressed() -> void:
	panel_desplegable.visible = not panel_desplegable.visible

func actualizar_dinero(monto: int) -> void:
	label_dinero.text = "Dinero: $" + str(monto)

# --- CANASTA SOLO LECTURA EN MERCADO ---
func actualizar_canasta() -> void:
	for hijo in lista_productos.get_children():
		hijo.queue_free()
		
	if DatosJugador.canasta.size() == 0:
		var label_vacio = Label.new()
		label_vacio.text = "(Canasta vacía)"
		lista_productos.add_child(label_vacio)
	else:
		for item in DatosJugador.canasta:
			var fila = HBoxContainer.new()
			
			# Miniatura del producto
			var img_mini = TextureRect.new()
			if item["imagen"] != "" and ResourceLoader.exists(item["imagen"]):
				img_mini.texture = load(item["imagen"])
			img_mini.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			img_mini.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			img_mini.custom_minimum_size = Vector2(24, 24)
			
			# Nombre y Precio
			var label = Label.new()
			label.text = item["nombre"] + " ($" + str(item["precio"]) + ")"
			
			fila.add_child(img_mini)
			fila.add_child(label)
			
			# Se agrega a la lista sin botón de borrar
			lista_productos.add_child(fila)
