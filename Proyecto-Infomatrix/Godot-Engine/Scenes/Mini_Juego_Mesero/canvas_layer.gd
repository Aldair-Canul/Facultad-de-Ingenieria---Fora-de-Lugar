extends CanvasLayer

# Referencias a tus tres nodos de corazones
@onready var corazones = [$Corazones/Corazon1, $Corazones/Corazon2, $Corazones/Corazon3]

func _ready():
	# Dejamos la función lista por si necesitas inicializar algo después
	pass 

# Esta función la llamará el mesero automáticamente cada vez que un perro lo muerda
func actualizar_corazones(vidas_restantes: int):
	# Recorremos la lista de corazones para prenderlos o apagarlos
	for i in range(corazones.size()):
		if i < vidas_restantes:
			corazones[i].visible = true
		else:
			corazones[i].visible = false
			
	# Si las vidas llegan a cero, ejecutamos el Game Over
	if vidas_restantes <= 0:
		activar_game_over()

# Función que cambia a la pantalla de Game Over
func activar_game_over():
	# Apuntamos a la carpeta exacta donde guardaste el Game Over
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Mini_Juego_Mesero/game_over.tscn")
