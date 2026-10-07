extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.modulate.a = 0.0
	# Permite que el mouse atraviese el recuadro cuando no hay transición
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func change_scene(target_scene_path: String, duracion: float = 0.5) -> void:
	# Bloquea clics durante el desvanecimiento para evitar clics accidentales
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var tween := create_tween()
	
	# 1. Transición a negro (Fade In)
	tween.tween_property(color_rect, "modulate:a", 1.0, duracion)
	
	# 2. Cambiar escena
	tween.tween_callback(Callable(self, "_cambiar_escena").bind(target_scene_path))
	
	# 3. Transición a transparente (Fade Out)
	tween.tween_property(color_rect, "modulate:a", 0.0, duracion)
	
	# 4. Liberar el mouse al finalizar
	tween.tween_callback(func(): color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE)

func _cambiar_escena(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
