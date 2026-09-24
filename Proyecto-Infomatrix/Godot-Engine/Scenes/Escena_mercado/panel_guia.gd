extends VBoxContainer

@export var boton_desplegar: Button
@export var contenido_guia: Control

var esta_abierto: bool = false
var tween: Tween

func _ready() -> void:
	if boton_desplegar:
		boton_desplegar.pressed.connect(_alternar_guia)
		boton_desplegar.text = "💡 Misiones / Guía  ▼"
	
	if contenido_guia:
		contenido_guia.visible = false
		contenido_guia.modulate.a = 0.0

func _alternar_guia() -> void:
	if not contenido_guia or not boton_desplegar:
		return
		
	esta_abierto = not esta_abierto
	
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if esta_abierto:
		contenido_guia.visible = true
		boton_desplegar.text = "💡 Misiones / Guía  ▲"
		tween.tween_property(contenido_guia, "modulate:a", 1.0, 0.3)
	else:
		boton_desplegar.text = "💡 Misiones / Guía  ▼"
		tween.tween_property(contenido_guia, "modulate:a", 0.0, 0.2)
		tween.chain().tween_callback(func(): contenido_guia.visible = false)
