extends CanvasLayer

@onready var label_dinero: Label = $ContenedorDinero/Labeldinero
@onready var boton_canasta: TextureButton = $canasta/BotonCanasta
@onready var panel_desplegable: PanelContainer = $canasta/PanelDesplegable
@onready var lista_productos: VBoxContainer = $canasta/PanelDesplegable/ScrollCanasta/ListaProductos
@onready var contenedor_tienda: Container = $ScrollTienda/ListadeCompras
@onready var boton_salir: Button = $BotonSalir

const RUTA_ASSETS: String = "res://Scenes/escena super/assets objetos compras super/"
const RUTA_ICONO_COMPRAR: String = "res://Scenes/Escena_mercado/estantes separados/boton agregar.png"

var catalogo: Array = [
	{"nombre": "Papel Triple Hoja", "precio": 45, "imagen": RUTA_ASSETS + "papel_premium_triple_hoja.png"},
	{"nombre": "Pasta Codito", "precio": 12, "imagen": RUTA_ASSETS + "pasta_economica_codito.png"},
	{"nombre": "Pasta Spaghetti", "precio": 18, "imagen": RUTA_ASSETS + "pasta_normal_spaghetti.png"},
	{"nombre": "Pasta Integral", "precio": 25, "imagen": RUTA_ASSETS + "pasta_premium_integral.png"},
	{"nombre": "Aceite Vegetal", "precio": 32, "imagen": RUTA_ASSETS + "aceite_economico_vegetal.png"},
	{"nombre": "Aceite Puro", "precio": 48, "imagen": RUTA_ASSETS + "aceite_normal_puro.png"},
	{"nombre": "Aceite de Oliva", "precio": 75, "imagen": RUTA_ASSETS + "aceite_premium_oliva.png"},
	{"nombre": "Arroz Súper Extra", "precio": 16, "imagen": RUTA_ASSETS + "arroz_economico_super_extra.png"},
	{"nombre": "Arroz Extra", "precio": 24, "imagen": RUTA_ASSETS + "arroz_normal_extra.png"},
	{"nombre": "Arroz Premium", "precio": 38, "imagen": RUTA_ASSETS + "arroz_premium.png"}
]

func _ready() -> void:
	boton_salir.pressed.connect(_on_boton_salir_pressed)
	boton_canasta.pressed.connect(_on_boton_canasta_pressed)
	
	# Solo conectamos la señal de la canasta para actualizar productos
	DatosJugador.inventario_actualizado.connect(actualizar_canasta)
	
	mostrar_dinero()
	generar_tienda_dinamica()
	actualizar_canasta()

func _on_boton_canasta_pressed() -> void:
	panel_desplegable.visible = not panel_desplegable.visible

# Muestra el dinero que trae el jugador al entrar a la escena
func mostrar_dinero() -> void:
	label_dinero.text = "Disponible: $" + str(DatosJugador.dinero)

func generar_tienda_dinamica() -> void:
	if has_node("ScrollTienda"):
		var scroll = $ScrollTienda as ScrollContainer
		# 1. Desactivamos el scroll vertical sobrante
		scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		# 2. Ajustamos la altura del ScrollContainer al alto real de la tarjeta (205px)
		scroll.custom_minimum_size.y = 205

	for hijo in contenedor_tienda.get_children():
		hijo.queue_free()
		
	for prod in catalogo:
		var tarjeta = PanelContainer.new()
		# Ajustamos la tarjeta a 195px de alto
		tarjeta.custom_minimum_size = Vector2(120, 195)
		
		var margin = MarginContainer.new()
		margin.add_theme_constant_override("margin_top", 4)
		margin.add_theme_constant_override("margin_bottom", 6)
		margin.add_theme_constant_override("margin_left", 6)
		margin.add_theme_constant_override("margin_right", 6)
		
		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.add_theme_constant_override("separation", 2)
		
		# Imagen del producto
		var tex = TextureRect.new()
		if ResourceLoader.exists(prod["imagen"]):
			tex.texture = load(prod["imagen"])
			
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex.custom_minimum_size = Vector2(52, 52)
		
		# Nombre del producto
		var label_nombre = Label.new()
		label_nombre.text = prod["nombre"]
		label_nombre.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label_nombre.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label_nombre.custom_minimum_size = Vector2(100, 32)
		
		# Precio
		var label_precio = Label.new()
		label_precio.text = "$" + str(prod["precio"])
		label_precio.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		# Botón
		var btn = TextureButton.new()
		if ResourceLoader.exists(RUTA_ICONO_COMPRAR):
			btn.texture_normal = load(RUTA_ICONO_COMPRAR)
			btn.ignore_texture_size = true
			btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		
		btn.custom_minimum_size = Vector2(100, 32)
		btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		btn.pressed.connect(_al_hacer_clic_comprar.bind(prod["nombre"], prod["precio"], prod["imagen"]))
		
		vbox.add_child(tex)
		vbox.add_child(label_nombre)
		vbox.add_child(label_precio)
		vbox.add_child(btn)
		
		margin.add_child(vbox)
		tarjeta.add_child(margin)
		
		contenedor_tienda.add_child(tarjeta)
func _al_hacer_clic_comprar(nombre: String, precio: int, imagen: String) -> void:
	# Agrega al carrito (el dinero no cambia aquí)
	DatosJugador.agregar_al_carrito(nombre, precio, imagen)

# --- ACTUALIZAR CANASTA Y MOSTRAR TOTAL ---
func actualizar_canasta() -> void:
	for hijo in lista_productos.get_children():
		hijo.queue_free()
	
	if DatosJugador.canasta.size() == 0:
		var label_vacio = Label.new()
		label_vacio.text = "(Canasta vacía)"
		lista_productos.add_child(label_vacio)
	else:
		for i in range(DatosJugador.canasta.size()):
			var item = DatosJugador.canasta[i]
			var fila = HBoxContainer.new()
			
			var img_mini = TextureRect.new()
			if item["imagen"] != "" and ResourceLoader.exists(item["imagen"]):
				img_mini.texture = load(item["imagen"])
			img_mini.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			img_mini.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			img_mini.custom_minimum_size = Vector2(24, 24)
			
			var label = Label.new()
			label.text = item["nombre"] + " ($" + str(item["precio"]) + ")"
			label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			
			var btn_eliminar = Button.new()
			btn_eliminar.text = " X "
			btn_eliminar.pressed.connect(_al_eliminar_producto.bind(i))
			
			fila.add_child(img_mini)
			fila.add_child(label)
			fila.add_child(btn_eliminar)
			lista_productos.add_child(fila)
		
		# Fila final con el total a pagar en la caja
		var label_total = Label.new()
		label_total.text = "-------------------\nTotal en caja: $" + str(DatosJugador.obtener_total_a_pagar())
		lista_productos.add_child(label_total)

func _al_eliminar_producto(indice: int) -> void:
	DatosJugador.eliminar_producto(indice)

func _on_boton_salir_pressed() -> void:
	DatosJugador.super_visitado = true
	DatosJugador.compra_lista = true
	get_tree().change_scene_to_file("res://Scenes/Escena_mercado/mercado.tscn")
