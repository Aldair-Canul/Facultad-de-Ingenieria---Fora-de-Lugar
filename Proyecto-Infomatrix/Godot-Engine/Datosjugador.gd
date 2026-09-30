extends Node

# Señales para avisar a la interfaz
signal inventario_actualizado
signal dinero_cambiado(nuevo_monto)

var super_visitado = false

# iniciamos con $500 
var dinero: int = 500 
var canasta: Array = [] # Guardará los productos: [{"nombre": "Leche", "precio": 20}]

# --- FUNCIÓN PARA EL MESERO (FUTURO) ---
func ganar_dinero(monto: int) -> void:
	dinero += monto
	dinero_cambiado.emit(dinero)
	print("¡Propina/Pago recibido! Ganaste: $", monto, " | Total: $", dinero)

# Funcion para tienda

func comprar_producto(nombre: String, precio: int, ruta_imagen: String = "") -> bool:
	if dinero >= precio:
		dinero -= precio
		canasta.append({"nombre": nombre, "precio": precio, "imagen": ruta_imagen})
		inventario_actualizado.emit()
		dinero_cambiado.emit(dinero)
		print("Comprado: ", nombre, " | Restante: $", dinero)
		return true
	else:
		print("¡Dinero insuficiente para comprar ", nombre, "!")
		return false
#funcion para el reembolso
func eliminar_producto(indice: int) -> void:
	if indice >= 0 and indice < canasta.size():
		var producto = canasta[indice]
		dinero += producto["precio"] # Devuelve el dinero
		canasta.remove_at(indice)    # Lo saca de la lista
		
		# Avisa a la interfaz para que se redibuje
		inventario_actualizado.emit()
		dinero_cambiado.emit(dinero)
		print("Eliminado: ", producto["nombre"], " | Reembolsado: $", producto["precio"])
