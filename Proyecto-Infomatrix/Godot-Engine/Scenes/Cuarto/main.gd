extends Node2D

@onready var player = $Player
@onready var anim_transicion = $Transition/AnimationPlayer


var pos_en_bano = Vector2(1400, 400) #vector de posicion
var pos_en_cuarto = Vector2(250, 400)
var tiene_mochila = false

var segundos_totales = 30

func teletransportar(destino: Vector2):
	player.set_physics_process(false)
	
	if anim_transicion.has_animation("fade_out"):
		anim_transicion.play("fade_out")
		await anim_transicion.animation_finished
	
	player.global_position = destino
	
	if anim_transicion.has_animation("fade_in"):
		anim_transicion.play("fade_in")
		await anim_transicion.animation_finished
		
	player.set_physics_process(true)

func _on_door_zone_room_body_entered(body):
	print("¡Algo tocó la puerta del cuarto! Fue: ", body.name)
	if body.name == "Player":
		print("Teletransportando al baño...")
		teletransportar(pos_en_bano)
		
func _on_door_zone_bath_body_entered(body):
	print("¡Algo tocó la puerta del baño! Fue: ", body.name)
	if body.name == "Player":
		print("Teletransportando al cuarto...")
		teletransportar(pos_en_cuarto)

func _on_objeto_mochila_body_entered(body):
	print("¡Algo tocó la mochila! Fue: ", body.name)
	if body.name == "Player":
		tiene_mochila = true
		
		# 1. Eliminamos la mochila del mapa
		$World/ObjetoMochila.queue_free()
		
		# 2. Actualizamos el texto del objetivo
		$UI/HUD/ObjetivosLabel.text = "Objetivo: Acomodar mochila"
		
		# 3. Mostramos el objeto y el botón en el inventario
		$UI/HUD/PanelInventario/TextoObjetos.text = "- Mochila" 
		$UI/HUD/PanelInventario/BtnUsarMochila.visible = true 

func _on_btn_usar_mochila_pressed():
	if tiene_mochila == true:
		tiene_mochila = false
		
		# 1. Hacemos visible la mochila en el cuarto
		$World/MochilaAcomodada.visible = true
		
		# 2. Actualizamos el inventario y objetivos
		$UI/HUD/PanelInventario/BtnUsarMochila.visible = false
		$UI/HUD/PanelInventario/TextoObjetos.text = "Inventario vacío"
		$UI/HUD/ObjetivosLabel.text = "Objetivo: ¡Completado!"
		
		# 3. Cerramos el panel y detenemos el reloj
		$UI/HUD/PanelInventario.visible = false
		$TimerReloj.stop()
		
		# 4. MOSTRAMOS LA VICTORIA Y DETENEMOS AL JUGADOR
		$UI/HUD/PanelVictoria.visible = true
		player.set_physics_process(false)

# Función que se ejecuta cada segundo gracias al TimerReloj
func _on_timer_reloj_timeout():
	if segundos_totales > 0:
		segundos_totales -= 1
		var minutos = segundos_totales / 60
		var segundos = segundos_totales % 60
		$UI/HUD/RelojLabel.text = "%02d:%02d" % [minutos, segundos]
	else:
		$TimerReloj.stop()
		$UI/HUD/RelojLabel.text = "00:00"
		$UI/HUD/ObjetivosLabel.text = "¡Tiempo agotado!"
		
		# Mostramos la pantalla de Game Over y detenemos al jugador
		$UI/HUD/PanelGameOver.visible = true
		player.set_physics_process(false)
 

func _on_btn_reintentar_pressed() -> void:
	get_tree().reload_current_scene()


func _on_final_cuarto_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Juego_Cuarto/final_cuarto.tscn")
