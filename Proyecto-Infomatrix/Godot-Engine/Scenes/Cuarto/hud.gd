extends Control

@onready var panel_inventario = $PanelInventario

func _on_button_inventario_pressed():
	print("¡El botón funciona!")
	panel_inventario.visible = not panel_inventario.visible
