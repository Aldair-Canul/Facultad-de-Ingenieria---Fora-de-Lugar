extends Node2D

# ==========================================
# VARIABLES
# ==========================================
# Variables del tutorial
var tutorial_oculto = false

# Variables del minijuego
var objetos_colocados = 0
var total_objetos = 3 # Cambia esto al número real de tus muebles (Cama, Mesa, Silla)

# Referencia a la pantalla de victoria (Asegúrate de que la ruta coincida con tu árbol de nodos)
@onready var pantalla_victoria = $CanvasLayer/PantallaVictoria

# ==========================================
# FUNCIÓN DE INICIO
# ==========================================
func _ready():
	# Nos aseguramos de que la pantalla de victoria esté oculta al iniciar
	if pantalla_victoria != null:
		pantalla_victoria.hide()

# ==========================================
# ENTRADA DE CONTROLES (TUTORIAL)
# ==========================================
func _input(event):
	# Verificamos si el tutorial sigue visible y si el evento es un botón del mouse
	if not tutorial_oculto and event is InputEventMouseButton:
		# Verificamos que sea un clic izquierdo y que esté presionado
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
			# Buscamos tu nodo de texto en el CanvasLayer
			var texto_tutorial = $CanvasLayer/PanelContainer 
			
			if texto_tutorial != null:
				texto_tutorial.hide()
				tutorial_oculto = true # Marcamos que ya se ocultó

# ==========================================
# LÓGICA DE LAS ZONAS (SEÑALES)
# ==========================================
# Conecta estas señales desde el panel "Nodos" de tus Area2D

# --- PARA LA CAMA ---
func _on_zona_cama_area_entered(area):
	if area.name == "Cama": 
		objetos_colocados += 1
		verificar_victoria()

func _on_zona_cama_area_exited(area):
	if area.name == "Cama": 
		objetos_colocados -= 1

# --- PARA LA SILLA ---
func _on_zona_silla_area_entered(area):
	if area.name == "Silla": 
		objetos_colocados += 1
		verificar_victoria()

func _on_zona_silla_area_exited(area):
	if area.name == "Silla": 
		objetos_colocados -= 1

# --- PARA LA MESA ---
func _on_zona_mesa_area_entered(area):
	if area.name == "Mesa": 
		objetos_colocados += 1
		verificar_victoria()

func _on_zona_mesa_area_exited(area):
	if area.name == "Mesa": 
		objetos_colocados -= 1


# ==========================================
# SISTEMA DE VICTORIA
# ==========================================
func verificar_victoria():
	if objetos_colocados == total_objetos:
		mostrar_final()

func mostrar_final():
	# Hacemos visible la interfaz final
	if pantalla_victoria != null:
		pantalla_victoria.show()
	
	# Imprimimos en consola para verificar que funciona
	print("El cuarto quedo listo")
	
	# Opcional: Detener el juego para que no se sigan moviendo las cosas
	# get_tree().paused = true
