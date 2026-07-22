extends Area2D

var dragging = false
var offset = Vector2(0, 0)

# --- VARIABLES DEL IMÁN (CONFIGURADAS EN EL SCRIPT) ---
var locked = false

# Coordenadas X y Y del centro de tu cuarto. 
# (576, 324) es el centro exacto de la pantalla por defecto en Godot.
var target_position = Vector2(-180, 304) 

# Qué tan cerca debes soltar la cama para que el imán la atrape
var snap_distance = 150.0 

func _process(delta):
	if dragging and not locked:
		global_position = get_global_mouse_position() + offset

func _on_input_event(viewport, event, shape_idx):
	if locked:
		return 
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			offset = global_position - get_global_mouse_position()
		else:
			dragging = false
			check_snap()

func check_snap():
	if global_position.distance_to(target_position) < snap_distance:
		global_position = target_position
		locked = true
		print("¡Cama colocada en el centro!")


func _on_area_mesa_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
