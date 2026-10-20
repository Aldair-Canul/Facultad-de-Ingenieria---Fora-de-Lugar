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
	{"nombre": "Aceite de Oliva", "precio": 80, "imagen": RUTA_ASSETS + "aceite_premium_oliva.png"},
	{"nombre": "Arroz Súper Extra", "precio": 16, "imagen": RUTA_ASSETS + "arroz_economico_super_extra.png"},
	{"nombre": "Arroz Extra", "precio": 24, "imagen": RUTA_ASSETS + "arroz_normal_extra.png"},
	{"nombre": "Arroz Premium", "precio": 38, "imagen": RUTA_ASSETS + "arroz_premium.png"},
	{"nombre": "Azúcar Estándar", "precio": 18, "imagen": RUTA_ASSETS + "azucar_economica_estandar.png"},
	{"nombre": "Azúcar Refinada", "precio": 26, "imagen": RUTA_ASSETS + "azucar_normal_refinada.png"},
	{"nombre": "Azúcar Morena", "precio": 38, "imagen": RUTA_ASSETS + "azucar_premium_morena.png"},
	{"nombre": "Café Soluble", "precio": 35, "imagen": RUTA_ASSETS + "cafe_economico_soluble.png"},
	{"nombre": "Café Clásico", "precio": 55, "imagen": RUTA_ASSETS + "cafe_normal_clasico.png"},
	{"nombre": "Café Premium", "precio": 95, "imagen": RUTA_ASSETS + "cafe_premium.png"},
	{"nombre": "Frijol Negro", "precio": 22, "imagen": RUTA_ASSETS + "frijol_economico_negro.png"},
	{"nombre": "Frijol Pinto", "precio": 30, "imagen": RUTA_ASSETS + "frijol_normal_pinto.png"},
	{"nombre": "Huevo Blanco", "precio": 35, "imagen": RUTA_ASSETS + "huevo_economico_blanco.png"},
	{"nombre": "Huevo Fresco", "precio": 48, "imagen": RUTA_ASSETS + "huevo_normal_fresco.png"},
	{"nombre": "Huevo Orgánico", "precio": 69, "imagen": RUTA_ASSETS + "huevo_premium_organico.png"},
	{"nombre": "Leche en Polvo", "precio": 25, "imagen": RUTA_ASSETS + "leche_economica_polvo.png"},
	{"nombre": "Leche Entera", "precio": 32, "imagen": RUTA_ASSETS + "leche_normal_entera.png"},
	{"nombre": "Leche Deslactosada", "precio": 42, "imagen": RUTA_ASSETS + "leche_premium_deslactosada.png"},
	{"nombre": "Papel Sencillo", "precio": 15, "imagen": RUTA_ASSETS + "papel_economico_sencillo.png"},
	{"nombre": "Papel Doble Hoja", "precio": 28, "imagen": RUTA_ASSETS + "papel_normal_doble_hoja.png"},
	{"nombre": "Atún en Agua", "precio": 18, "imagen": RUTA_ASSETS + "atun_economico_en_agua.png"},
	{"nombre": "Atún en Aceite", "precio": 25, "imagen": RUTA_ASSETS + "atun_normal_en_aceite.png"},
	{"nombre": "Atún Premium", "precio": 38, "imagen": RUTA_ASSETS + "atun_premium.png"}
]

func _ready() -> void:
	boton_salir.pressed.connect(_on_boton_salir_pressed)
	boton_canasta.pressed.connect(_on_boton_canasta_pressed)
	
	if DatosJugador.has_signal("inventario_actualizado"):
		DatosJugador.inventario_actualizado.connect(actualizar_canasta)
	
	mostrar_dinero()
	generar_tienda_dinamica()
	actualizar_canasta()

func _on_boton_canasta_pressed() -> void:
	panel_desplegable.visible = not panel_desplegable.visible

func mostrar_dinero() -> void:
	label_dinero.text = "Disponible: $" + str(DatosJugador.dinero)

func generar_tienda_dinamica() -> void:
	if has_node("ScrollTienda"):
		var scroll = $ScrollTienda as ScrollContainer
		scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_ALWAYS
		scroll.custom_minimum_size.y = 205
		
		
		var estilo = StyleBoxFlat.new()
		estilo.bg_color = Color("#241812d9") 
		estilo.corner_radius_top_left = 6
		estilo.corner_radius_top_right = 6
		estilo.corner_radius_bottom_left = 6
		estilo.corner_radius_bottom_right = 6
		
		scroll.add_theme_stylebox_override("panel", estilo)

		
		var h_bar = scroll.get_h_scroll_bar()
		
		h_bar.custom_minimum_size.y = 22
		
		var textura_flechas = _crear_textura_grabber_pixelart()
		
		var estilo_grabber = StyleBoxTexture.new()
		estilo_grabber.texture = textura_flechas
		
		
		estilo_grabber.texture_margin_left = 18
		estilo_grabber.texture_margin_right = 18
		estilo_grabber.texture_margin_top = 3
		estilo_grabber.texture_margin_bottom = 3
		
		
		estilo_grabber.expand_margin_top = -2
		estilo_grabber.expand_margin_bottom = -2
		
		h_bar.add_theme_stylebox_override("grabber", estilo_grabber)
		h_bar.add_theme_stylebox_override("grabber_highlight", estilo_grabber)
		h_bar.add_theme_stylebox_override("grabber_pressed", estilo_grabber)
		
		
		var estilo_carril = StyleBoxFlat.new()
		estilo_carril.bg_color = Color("#14100e")
		estilo_carril.corner_radius_top_left = 4
		estilo_carril.corner_radius_top_right = 4
		estilo_carril.corner_radius_bottom_left = 4
		estilo_carril.corner_radius_bottom_right = 4
		
		h_bar.add_theme_stylebox_override("scroll", estilo_carril)

	for hijo in contenedor_tienda.get_children():
		hijo.queue_free()
		
	for prod in catalogo:
		var tarjeta = PanelContainer.new()
		tarjeta.custom_minimum_size = Vector2(120, 195)
		
		var margin = MarginContainer.new()
		margin.add_theme_constant_override("margin_top", 4)
		margin.add_theme_constant_override("margin_bottom", 6)
		margin.add_theme_constant_override("margin_left", 6)
		margin.add_theme_constant_override("margin_right", 6)
		
		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.add_theme_constant_override("separation", 2)
		
		var tex = TextureRect.new()
		if ResourceLoader.exists(prod["imagen"]):
			tex.texture = load(prod["imagen"])
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex.custom_minimum_size = Vector2(52, 52)
		
		var label_nombre = Label.new()
		label_nombre.text = prod["nombre"]
		label_nombre.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label_nombre.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label_nombre.custom_minimum_size = Vector2(100, 32)
		
		var label_precio = Label.new()
		label_precio.text = "$" + str(prod["precio"])
		label_precio.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
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


func _crear_textura_grabber_pixelart() -> ImageTexture:
	var ancho = 52
	var alto = 18
	var img = Image.create(ancho, alto, false, Image.FORMAT_RGBA8)
	
	var color_fondo = Color("#e58e26")       
	var color_borde = Color("#a05e17")       
	var color_simbolo = Color("#14100e")     
	var color_transparente = Color(0, 0, 0, 0)
	
	img.fill(color_fondo)
	

	img.set_pixel(0, 0, color_transparente)
	img.set_pixel(0, alto - 1, color_transparente)
	img.set_pixel(ancho - 1, 0, color_transparente)
	img.set_pixel(ancho - 1, alto - 1, color_transparente)
	

	for x in range(1, ancho - 1):
		img.set_pixel(x, 0, color_borde)
		img.set_pixel(x, alto - 1, color_borde)
	for y in range(1, alto - 1):
		img.set_pixel(0, y, color_borde)
		img.set_pixel(ancho - 1, y, color_borde)
		

	var puntos_izq = [
		Vector2i(12, 4), Vector2i(11, 5), Vector2i(10, 6), Vector2i(9, 7),
		Vector2i(8, 8), Vector2i(8, 9), Vector2i(9, 10), Vector2i(10, 11),
		Vector2i(11, 12), Vector2i(12, 13)
	]
	for p in puntos_izq:
		img.set_pixel(p.x, p.y, color_simbolo)
		img.set_pixel(p.x + 1, p.y, color_simbolo) # Grosor extra
		

	var puntos_der = [
		Vector2i(39, 4), Vector2i(40, 5), Vector2i(41, 6), Vector2i(42, 7),
		Vector2i(43, 8), Vector2i(43, 9), Vector2i(42, 10), Vector2i(41, 11),
		Vector2i(40, 12), Vector2i(39, 13)
	]
	for p in puntos_der:
		img.set_pixel(p.x, p.y, color_simbolo)
		img.set_pixel(p.x - 1, p.y, color_simbolo) # Grosor extra
		
	return ImageTexture.create_from_image(img)

func _al_hacer_clic_comprar(nombre: String, precio: int, imagen: String) -> void:
	if not nombre in DatosJugador.lista_requerida:
		print("'" + nombre + "' no está en la lista de compras.")
		return

	if DatosJugador.lista_requerida[nombre]["comprado"]:
		print("Ya agregaste '" + nombre + "' al carrito.")
		return

	DatosJugador.agregar_al_carrito(nombre, precio, imagen)

func actualizar_canasta() -> void:
	for hijo in lista_productos.get_children():
		hijo.queue_free()
	
	var titulo_lista = Label.new()
	titulo_lista.text = "--- LISTA DE DESPENSA ---"
	titulo_lista.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lista_productos.add_child(titulo_lista)
	
	# Dibuja la lista requerida con sus estados [✔] o [ ]
	for nombre_req in DatosJugador.lista_requerida:
		var item_info = DatosJugador.lista_requerida[nombre_req]
		var item_label = Label.new()
		
		if item_info["comprado"]:
			item_label.text = "[✔] " + nombre_req + " ($" + str(item_info["precio"]) + ")"
			item_label.modulate = Color.GREEN
		else:
			item_label.text = "[ ] " + nombre_req + " ($" + str(item_info["precio"]) + ")"
			item_label.modulate = Color(0.8, 0.8, 0.8, 1.0)
			
		lista_productos.add_child(item_label)
		
	var separador = Label.new()
	separador.text = "-------------------"
	separador.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lista_productos.add_child(separador)

	# Elementos en el carrito
	if DatosJugador.canasta.size() == 0:
		var label_vacio = Label.new()
		label_vacio.text = "(Carrito vacío)"
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
		
	# Resumen final
	var label_total = Label.new()
	var total_actual = DatosJugador.obtener_total_a_pagar()
	label_total.text = "Total a pagar: $" + str(total_actual) + " / $500"
	
	if total_actual == 500 and DatosJugador.compra_lista:
		label_total.modulate = Color.GREEN
	else:
		label_total.modulate = Color.YELLOW
		
	lista_productos.add_child(label_total)

func _al_eliminar_producto(indice: int) -> void:
	DatosJugador.eliminar_producto(indice)

func _on_boton_salir_pressed() -> void:
	DatosJugador.super_visitado = true
	DatosJugador.verificar_estado_compra()
	TransicionPixel.change_scene("res://Scenes/Escena_mercado/mercado.tscn")
