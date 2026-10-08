extends CanvasLayer

@onready var corazones = [$Corazones/Corazon1, $Corazones/Corazon2, $Corazones/Corazon3]
@onready var label_platillos: Label = get_node_or_null("LabelPlatillos")

func _ready() -> void:
	pass

func actualizar_platillos(actual: int, meta: int) -> void:
	if label_platillos:
		label_platillos.text = "Platillos entregados: " + str(actual) + " / " + str(meta)

func actualizar_corazones(vidas_restantes: int) -> void:
	for i in range(corazones.size()):
		if i < vidas_restantes:
			corazones[i].visible = true
		else:
			corazones[i].visible = false
			
	if vidas_restantes <= 0:
		activar_game_over()

func activar_game_over() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Mini_Juego_Mesero/game_over.tscn")
