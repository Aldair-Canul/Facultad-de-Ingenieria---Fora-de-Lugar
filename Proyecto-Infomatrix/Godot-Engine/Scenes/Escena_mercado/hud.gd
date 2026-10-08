extends CanvasLayer

@onready var label_dinero: Label = $ContenedorDinero/LabelDinero
@onready var boton_canasta: TextureButton = $Canasta/BotonCanasta
@onready var panel_desplegable: PanelContainer = $Canasta/PanelDesplegable
@onready var lista_productos: VBoxContainer = $Canasta/PanelDesplegable/ScrollCanasta/ListaProductos

# Nodos de Controles e Información
@onready var boton_info: TextureButton = $BotonInfo
@onready var mensaje_inicial: PanelContainer = $MensajeInicial
@onready var panel_controles: Control = $PanelControles
@onready var boton_back: TextureButton = $PanelControles/BotonBack

func _ready() -> void:
	# Conectamos el botón para abrir/cerrar la canasta
	boton_canasta.pressed.connect(_on_boton_canasta_pressed)
	
	# Conectamos señales globales
	DatosJugador.dinero_cambiado.connect(actualizar_dinero)
	DatosJugador.inventario_actualizado.connect(actualizar_canasta)
	
	# Conectamos botones de la ventana de controles
	if boton_info:
		boton_info.pressed.connect(mostrar_controles)
	if boton_back:
		boton_back.pressed.connect(ocultar_controles)
		
	# Iniciar con el panel de controles oculto
	if panel_controles:
		panel_controles.visible = false
	
	# Cargamos datos iniciales
	actualizar_dinero(DatosJugador.dinero)
	actualizar_canasta()
	
	# Muestra el banner temporal de inicio
	mostrar_mensaje_temporal()

# --- BANNER TEMPORAL DE BIENVENIDA ---
func mostrar_mensaje_temporal() -> void:
	if mensaje_inicial:
		mensaje_inicial.visible = true
		await get_tree().create_timer(4.5).timeout
		mensaje_inicial.visible = false

# --- TECLA DE ACCESO RÁPIDO ('I') ---
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_I:
			if panel_controles.visible:
				ocultar_controles()
			else:
				mostrar_controles()

# --- ABRIR Y CERRAR CONTROLES ---
func mostrar_controles() -> void:
	if panel_controles:
		panel_controles.visible = true

func ocultar_controles() -> void:
	if panel_controles:
		panel_controles.visible = false

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
			
			lista_productos.add_child(fila)
		
		# Mostrar el total acumulado que se cobrará en la caja
		var label_total = Label.new()
		label_total.text = "-------------------\nTotal a pagar: $" + str(DatosJugador.obtener_total_a_pagar())
		lista_productos.add_child(label_total)
