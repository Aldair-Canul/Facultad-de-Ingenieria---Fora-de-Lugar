extends CanvasLayer

@onready var label_dinero: Label = $ContenedorDinero/Labeldinero
@onready var boton_canasta: TextureButton = $canasta/BotonCanasta
@onready var panel_desplegable: PanelContainer = $canasta/PanelDesplegable
@onready var lista_productos: VBoxContainer = $canasta/PanelDesplegable/ScrollCanasta/ListaProductos
@onready var contenedor_tienda: Container = $ScrollTienda/ListadeCompras
@onready var boton_salir: Button = $BotonSalir

const RUTA_ASSETS: String = "res://Scenes/escena super/assets objetos compras super/"

const RUTA_ICONO_COMPRAR: String = "res://Scenes/Escena_mercado/estantes separados/boton comprar.png"

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
	
	DatosJugador.inventario_actualizado.connect(actualizar_canasta)
	DatosJugador.dinero_cambiado.connect(actualizar_dinero)
	
	actualizar_dinero(DatosJugador.dinero)
	generar_tienda_dinamica()
	actualizar_canasta()

func _on_boton_canasta_pressed() -> void:
	panel_desplegable.visible = not panel_desplegable.visible

func actualizar_dinero(nuevo_monto: int) -> void:
	label_dinero.text = "Dinero: $" + str(nuevo_monto)

func generar_tienda_dinamica() -> void:
	for hijo in contenedor_tienda.get_children():
		hijo.queue_free()
		
	for prod in catalogo:
		var tarjeta = PanelContainer.new()
		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var tex = TextureRect.new()
		if ResourceLoader.exists(prod["imagen"]):
			tex.texture = load(prod["imagen"])
			
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex.custom_minimum_size = Vector2(64, 64)
		
		var label = Label.new()
		label.text = prod["nombre"] + "\n$" + str(prod["precio"])
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		
		var btn = Button.new()
		
		if ResourceLoader.exists(RUTA_ICONO_COMPRAR):
			btn.icon = load(RUTA_ICONO_COMPRAR)
			btn.expand_icon = true
			btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		btn.text = "" 
		btn.custom_minimum_size = Vector2(48, 32)
		btn.pressed.connect(_al_hacer_clic_comprar.bind(prod["nombre"], prod["precio"], prod["imagen"]))
		
		vbox.add_child(tex)
		vbox.add_child(label)
		vbox.add_child(btn)
		tarjeta.add_child(vbox)
		
		contenedor_tienda.add_child(tarjeta)

func _al_hacer_clic_comprar(nombre: String, precio: int, imagen: String) -> void:
	DatosJugador.comprar_producto(nombre, precio, imagen)

# --- ACTUALIZAR CANASTE ---
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
			
			# Miniatura
			var img_mini = TextureRect.new()
			if item["imagen"] != "" and ResourceLoader.exists(item["imagen"]):
				img_mini.texture = load(item["imagen"])
			img_mini.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			img_mini.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			img_mini.custom_minimum_size = Vector2(24, 24)
			
			# Texto
			var label = Label.new()
			label.text = item["nombre"] + " ($" + str(item["precio"]) + ")"
			label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			
			# BOTÓN PARA ELIMINAR/DEVOLVER PRODUCTO
			var btn_eliminar = Button.new()
			btn_eliminar.text = " X "
			btn_eliminar.pressed.connect(_al_eliminar_producto.bind(i))
			
			fila.add_child(img_mini)
			fila.add_child(label)
			fila.add_child(btn_eliminar)
			lista_productos.add_child(fila)

func _al_eliminar_producto(indice: int) -> void:
	DatosJugador.eliminar_producto(indice)
	
func _on_boton_salir_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Escena_mercado/mercado.tscn")
