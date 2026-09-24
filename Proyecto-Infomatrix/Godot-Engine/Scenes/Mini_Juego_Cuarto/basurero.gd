extends Area2D

signal basura_depositada

@onready var sprite: Sprite2D = $Sprite2D

# Cargar las dos texturas
var tex_normal := preload("res://images/Chapter_1/basurero0.png")
var tex_resaltado := preload("res://images/Chapter_1/basurero1.png")

var jugador_cerca: bool = false
var se_puede_usar: bool = false # Se activa solo cuando el jugador ya recogió la basura

func activar_interaccion() -> void:
	se_puede_usar = true

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player" or body.is_in_group("player")) and se_puede_usar:
		jugador_cerca = true
		sprite.texture = tex_resaltado # Cambia al bote con contorno blanco

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		jugador_cerca = false
		sprite.texture = tex_normal

func _unhandled_input(event: InputEvent) -> void:
	# Al presionar 'E' o 'A' estando cerca y con la tarea activa
	if jugador_cerca and event.is_action_pressed("ui_accept"):
		emit_signal("basura_depositada")
		sprite.texture = tex_normal
		se_puede_usar = false
