extends Node2D

@onready var player = $Player
@onready var anim_transicion = $Transition/AnimationPlayer

var pos_en_bano = Vector2(1400, 400)
var pos_en_cuarto = Vector2(250, 400)

# Variables para saber qué objetos tenemos
var tiene_mochila = false
var tiene_cuaderno = false
var tiene_cama = false

var segundos_totales = 30

func _ready():
	$UI/HUD/PanelVictoria.visible = false
	$UI/HUD/PanelGameOver.visible = false
	$UI/HUD/PanelInventario.visible = false
	
	# Aseguramos que las cosas acomodadas empiecen invisibles si existen en la escena
	if has_node("World/MesaAcomodada"):
		$World/MesaAcomodada.visible = false
	if has_node("World/MochilaAcomodada"):
		$World/MochilaAcomodada.visible = false
	if has_node("World/CamaAcomodada"):
		$World/CamaAcomodada.visible = false
		
	$UI/HUD/ObjetivosLabel.text = "Objetivo: Encontrar Mochila, Cuaderno y Cama"
	$MusicaFondo.play()

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
	if body.name == "Player":
		teletransportar(pos_en_bano)
		
func _on_door_zone_bath_body_entered(body):
	if body.name == "Player":
		teletransportar(pos_en_cuarto)

# --- RECOGER MOCHILA ---
func _on_objeto_mochila_body_entered(body):
	if body.name == "Player":
		tiene_mochila = true
		if has_node("World/ObjetoMochila"):
			$World/ObjetoMochila.queue_free()
		actualizar_inventario_y_objetivos()

# --- RECOGER CUADERNO ---
func _on_objeto_cuaderno_body_entered(body):
	if body.name == "Player":
		tiene_cuaderno = true
		if has_node("World/ObjetoCuaderno"):
			$World/ObjetoCuaderno.queue_free()
		actualizar_inventario_y_objetivos()

# --- RECOGER CAMA ---
func _on_objeto_cama_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		tiene_cama = true
		if has_node("World/ObjetoCama"):
			$World/ObjetoCama.queue_free()
		actualizar_inventario_y_objetivos()

# Actualiza el inventario y el texto de objetivo según lo que tengas juntado
func actualizar_inventario_y_objetivos():
	var lista_objetos = ""
	if tiene_mochila:
		lista_objetos += "- Mochila\n"
	if tiene_cuaderno:
		lista_objetos += "- Cuaderno\n"
	if tiene_cama:
		lista_objetos += "- Cama\n"
		
	$UI/HUD/PanelInventario/TextoObjetos.text = lista_objetos
	
	# Verificamos si ya juntamos los 3 objetos
	if tiene_mochila and tiene_cuaderno and tiene_cama:
		$UI/HUD/ObjetivosLabel.text = "Objetivo: Acomodar cosas"
		$UI/HUD/PanelInventario/BtnUsarMochila.visible = true
	else:
		$UI/HUD/ObjetivosLabel.text = "Objetivo: Faltan objetos por encontrar"

func _on_btn_usar_mochila_pressed():
	if tiene_mochila and tiene_cuaderno and tiene_cama:
		tiene_mochila = false
		tiene_cuaderno = false
		tiene_cama = false
		
		# Hacemos visible lo acomodado si existe el nodo
		if has_node("World/MesaAcomodada"):
			$World/MesaAcomodada.visible = true
		if has_node("World/MochilaAcomodada"):
			$World/MochilaAcomodada.visible = true
		if has_node("World/CamaAcomodada"):
			$World/CamaAcomodada.visible = true
		
		$UI/HUD/PanelInventario/BtnUsarMochila.visible = false
		$UI/HUD/PanelInventario/TextoObjetos.text = "Inventario vacío"
		$UI/HUD/ObjetivosLabel.text = "Objetivo: ¡Completado!"
		
		$UI/HUD/PanelInventario.visible = false
		$TimerReloj.stop()
		$MusicaFondo.stop()
		$MusicaVictoria.play()
		$UI/HUD/PanelVictoria.visible = true
		player.set_physics_process(false)

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
		$UI/HUD/PanelGameOver.visible = true
		$MusicaFondo.stop()
		$MusicaDerrota.play()
		player.set_physics_process(false)

func _on_btn_reintentar_pressed():
	get_tree().reload_current_scene()

func _on_btn_volver_a_jugar_pressed():
	get_tree().reload_current_scene()

func _on_final_cuarto_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Juego_Cuarto/final_cuarto.tscn")
