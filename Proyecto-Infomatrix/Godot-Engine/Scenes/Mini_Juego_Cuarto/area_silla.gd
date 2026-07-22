extends Area2D

var dragging = false
var offset = Vector2(0, 0)

# --- VARIABLES DEL IMÁN ---
var locked = false

# Coordenadas X y Y del destino de la SILLA. 
var target_position = Vector2(-180, 234) 

# Qué tan cerca debes soltar la silla para que el imán la atrape
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
		print("¡Silla colocada en su lugar!")
