extends CanvasLayer

@onready var boton_info: TextureButton = $BotonInfo
@onready var panel_controles: Control = $PanelControles
@onready var boton_back: TextureButton = $PanelControles/BotonBack

func _ready() -> void:
	if panel_controles:
		panel_controles.visible = false
		
	if boton_info:
		boton_info.pressed.connect(mostrar_controles)
	if boton_back:
		boton_back.pressed.connect(ocultar_controles)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_I:
			if panel_controles and panel_controles.visible:
				ocultar_controles()
			else:
				mostrar_controles()

func mostrar_controles() -> void:
	if panel_controles:
		panel_controles.visible = true

func ocultar_controles() -> void:
	if panel_controles:
		panel_controles.visible = false
