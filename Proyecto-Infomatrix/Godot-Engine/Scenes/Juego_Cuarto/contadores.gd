extends Control

var tiempo_aumento = 0
var tiempo_reduccion = 20

@onready var texto_sube = $CronometroSube/TextoSube
@onready var texto_baja = $CronometroBaja/TextoBaja

func _ready():
	texto_sube.text = str(tiempo_aumento)
	texto_baja.text = str(tiempo_reduccion)

func _on_reloj_timeout():
	# 1. Lógica del contador que AUMENTA
	tiempo_aumento += 1
	texto_sube.text = str(tiempo_aumento)
	
	# 2. Lógica del contador que REDUCE
	if tiempo_reduccion > 0:
		tiempo_reduccion -= 1
		texto_baja.text = str(tiempo_reduccion)
		
	# 3. ¿Qué pasa cuando el tiempo llega a cero?
	if tiempo_reduccion == 0:
		# ¡Apagamos el reloj para que no siga contando!
		$Reloj.stop() 
		get_tree().change_scene_to_file("res://Scenes/Juego_Cuarto/final_cuarto.tscn")
