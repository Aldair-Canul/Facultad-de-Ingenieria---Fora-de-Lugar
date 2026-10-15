extends Node

signal inventario_actualizado
signal dinero_cambiado(nuevo_monto)

var super_visitado: bool = false
var compra_lista: bool = false

var dinero: int = 600 # Saldo inicial ($600)
var total_a_pagar: int = 0
var ultimo_monto_pagado: int = 0

# Lista de 10 productos de 10 categorías distintas ($500 exactos)
var lista_requerida: Dictionary = {
	"Pasta Integral": {"precio": 25, "comprado": false},
	"Frijol Pinto": {"precio": 30, "comprado": false},
	"Arroz Premium": {"precio": 38, "comprado": false},
	"Azúcar Morena": {"precio": 38, "comprado": false},
	"Atún Premium": {"precio": 38, "comprado": false},
	"Leche Deslactosada": {"precio": 42, "comprado": false},
	"Papel Triple Hoja": {"precio": 45, "comprado": false},
	"Huevo Orgánico": {"precio": 69, "comprado": false},
	"Aceite de Oliva": {"precio": 80, "comprado": false},
	"Café Premium": {"precio": 95, "comprado": false}
}

var canasta: Array = []

func verificar_estado_compra() -> bool:
	var suma: int = 0
	var faltan_items: bool = false
	
	for key in lista_requerida:
		if lista_requerida[key]["comprado"]:
			suma += lista_requerida[key]["precio"]
		else:
			faltan_items = true
			
	total_a_pagar = suma
	compra_lista = (not faltan_items and total_a_pagar == 500)
	return compra_lista

func obtener_total_a_pagar() -> int:
	return total_a_pagar

func pagar_compra() -> bool:
	var total = obtener_total_a_pagar()
	
	if compra_lista and dinero >= total:
		dinero -= total # $600 - $500 = $100 restantes
		ultimo_monto_pagado = total
		canasta.clear()
		total_a_pagar = 0
		compra_lista = false
		
		dinero_cambiado.emit(dinero)
		inventario_actualizado.emit()
		return true
	return false

func agregar_al_carrito(nombre: String, precio: int, ruta_imagen: String = "") -> void:
	canasta.append({"nombre": nombre, "precio": precio, "imagen": ruta_imagen})
	if nombre in lista_requerida:
		lista_requerida[nombre]["comprado"] = true
		
	verificar_estado_compra()
	inventario_actualizado.emit()

func eliminar_producto(indice: int) -> void:
	if indice >= 0 and indice < canasta.size():
		var producto = canasta[indice]
		var nombre = producto.get("nombre", "")
		if nombre in lista_requerida:
			lista_requerida[nombre]["comprado"] = false
			
		canasta.remove_at(indice)
		verificar_estado_compra()
		inventario_actualizado.emit()
