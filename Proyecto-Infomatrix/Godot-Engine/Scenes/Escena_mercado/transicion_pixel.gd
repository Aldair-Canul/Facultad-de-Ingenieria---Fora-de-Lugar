extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_resetear_shader()

func _resetear_shader() -> void:
	var mat = color_rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("pixel_size", 1.0)
		mat.set_shader_parameter("fade", 0.0)

# Función principal para cambiar de escena con la animación retro
func change_scene(target_scene: String) -> void:
	# 1. Bloquea clics durante la animación
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# 2. Reproduce el efecto de pixelación y oscurecimiento
	anim_player.play("pixel_in")
	await anim_player.animation_finished
	
	# 3. Cambia la escena
	get_tree().change_scene_to_file(target_scene)
	
	# 4. Despixela la nueva escena
	anim_player.play("pixel_out")
	await anim_player.animation_finished
	
	# 5. Libera los clics
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
