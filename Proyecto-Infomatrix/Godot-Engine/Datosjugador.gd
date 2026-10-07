extends Node

# Señales para avisar a la interfaz
signal inventario_actualizado
signal dinero_cambiado(nuevo_monto)

var super_visitado: bool = false
var compra_lista: bool = false # Se activa al salir del supermercado

var dinero: int = 500 
var canasta: Array = [] # Guardará los productos: [{"nombre": "Leche", "precio": 20, "imagen": "..."}]

# --- GANAR DINERO (PROPINA / TRABAJO) ---
#func ganar_dinero(monto: int) -> void:
#	dinero += monto
#	dinero_cambiado.emit(dinero)
#	print("¡Propina/Pago recibido! Ganaste: $", monto, " | Total: $", dinero)

# --- CARRITO DE COMPRAS (SIN DESCONTAR DINERO AÚN) ---
func agregar_al_carrito(nombre: String, precio: int, ruta_imagen: String = "") -> void:
	canasta.append({"nombre": nombre, "precio": precio, "imagen": ruta_imagen})
	inventario_actualizado.emit()
	print("Agregado al carrito: ", nombre, " ($", precio, ")")

func eliminar_producto(indice: int) -> void:
	if indice >= 0 and indice < canasta.size():
		var producto = canasta[indice]
		canasta.remove_at(indice)
		inventario_actualizado.emit()
		print("Quitado del carrito: ", producto["nombre"])

# --- CÁLCULO Y PAGO EN LA CAJA ---
func obtener_total_a_pagar() -> int:
	var total: int = 0
	for producto in canasta:
		total += producto.get("precio", 0)
	return total

func pagar_compra() -> bool:
	var total = obtener_total_a_pagar()
	if dinero >= total:
		dinero -= total
		canasta.clear()
		compra_lista = false # Reiniciamos la bandera
		dinero_cambiado.emit(dinero)
		inventario_actualizado.emit()
		print("¡Pago realizado! Dinero restante: $", dinero)
		return true
	else:
		print("¡No tienes suficiente dinero para pagar $", total, "!")
		return false
