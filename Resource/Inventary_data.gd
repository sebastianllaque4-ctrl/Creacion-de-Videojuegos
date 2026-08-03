extends Resource
class_name Inventory_data

signal inventory_changed

#Cantidad de slot que se crearan de slots
@export var size := 27
#Inicializa en array los slot
var slots : Array[slot_data] = []
var selected_slot := 0; 

#Inicializa el invetario y guarda el size en array para generar slot
func _init():
	slots.resize(size)
	for i in range(size):
		slots[i] = slot_data.new() 

#buscamos el slots sin items
func get_empty_slot() -> slot_data:
	for slot in slots:
		if slot.item == null:
			return slot
	return null

func search_items(item: items_data) -> slot_data:
	for slot in slots:
		if slot.item == item:
			return slot
	return null

#busca items stack 
func search_items_slot(item:items_data) -> slot_data:
	for slot in slots:
		if slot.item == item and slot.cant < item.max_stack:
			return slot
	return null

#Agrega Items 
func add_item(item: items_data,cant:int) -> bool :
	while cant > 0:
		if item.stackable:
			var slot = search_items_slot(item)
			if slot:
				var espacio = item.max_stack - slot.cant
				var agregar = min(espacio,cant)
				slot.cant += agregar
				cant -= agregar
				
			elif  slot == null:
				slot = get_empty_slot()
				if slot == null:
					return false
				var agregar = min(item.max_stack,cant)
				slot.cant = agregar
				slot.item = item
				cant -= agregar
				
		else:
			var slot = get_empty_slot()
			if slot == null:
					return false
			slot.item = item
			slot.cant = 1
			cant -= 1
	inventory_changed.emit()
	return true

func get_selected_slot() -> slot_data:
	return slots[selected_slot]

func get_selected_item() -> items_data:
	if slots[selected_slot].item:
		return slots[selected_slot].item
	return null
	
func select_slot(index:int):
	if index < 0 or index >= slots.size():
		return
	selected_slot = index
	inventory_changed.emit()

func move_slot(origen: int,destino:int):
	if origen == destino:
		return
	if slots[origen].item == null:
		return
	if slots[origen].item != null and slots[destino].item == null:
		swap_slots(origen,destino) 
		return
	if slots[origen].item == slots[destino].item:
		if slots[origen].item.stackable:
			var total = slots[origen].cant + slots[destino].cant
			var agregar = min(slots[destino].item.max_stack, total)
			slots[destino].cant = agregar
			slots[origen].cant = total - agregar
			
			if slots[origen].cant <= 0:
				slots[origen].item = null
				slots[origen].cant = 0
			
		else :
			swap_slots(origen,destino)
			
	elif slots[origen].item != slots[destino].item:
		swap_slots(origen,destino)
	inventory_changed.emit()
		
func swap_slots(origen:int,destino:int):
	var cant = slots[destino].cant
	var item = slots[destino].item
	slots[destino].item = slots[origen].item
	slots[destino].cant = slots[origen].cant
	slots[origen].item = item
	slots[origen].cant = cant 
	inventory_changed.emit()
