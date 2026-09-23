extends Node

# Señales para avisar a la interfaz cuando cambie el dinero o los productos
signal inventario_actualizado
signal dinero_cambiado(nuevo_monto)

# NOTA: Iniciamos con $500 para probar las compras del supermercado.
# Cuando conectes el trabajo del mesero, puedes cambiarlo a 0.
var dinero: int = 500 
var canasta: Array = [] # Guardará los productos: [{"nombre": "Leche", "precio": 20}]

# --- FUNCIÓN PARA EL MESERO (FUTURO) ---
func ganar_dinero(monto: int) -> void:
	dinero += monto
	dinero_cambiado.emit(dinero)
	print("¡Propina/Pago recibido! Ganaste: $", monto, " | Total: $", dinero)

# --- FUNCIÓN PARA LA TIENDA (AHORA) ---
# En DatosJugador.gd

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
