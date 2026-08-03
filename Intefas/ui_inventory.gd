extends Control

@onready var hut_bar : TextureRect = $hub_bar
@onready var bar : TextureRect = $bar

@onready var temporal_dragged =$dragged_items
@onready var temporal_icon = $dragged_items/TextureRect
@onready var temporal_label = $dragged_items/Label

var inventory : Inventory_data
var inventory_open = false
var inventory_slot = []
var hotbar_slots = []

var dragged_slot = -1

func _ready():
	set_process(false)
	for child in hut_bar.get_children():
		hotbar_slots.append(child)
	for child in bar.get_children():
		inventory_slot.append(child)
	for slot in inventory_slot:
		slot.slot_clicked.connect(dragged_slots)

func setup(inv: Inventory_data):
	inventory = inv
	inventory.inventory_changed.connect(update_inventory)
	inventory.inventory_changed.connect(update_hut_bar)

	update_inventory()
	update_hut_bar()
	
func update_inventory():
	
	for i in range(inventory_slot.size()):
		inventory_slot[i].slot_index = i
		inventory_slot[i].update_slot(inventory.slots[i])

func update_hut_bar():
	for i in range(hotbar_slots.size()):
		hotbar_slots[i].slot_index = i
		hotbar_slots[i].update_slot(inventory.slots[i])
		hotbar_slots[i].set_selected(
			i == inventory.selected_slot
		)
		
func _on_move_requested(origen:int,destino:int):
	inventory.move_slot(origen,destino)

func set_invetory(value:bool):
	inventory_open = value
	if inventory_open == false:
		dragged_slot = -1
		set_process(false)
	for slot in inventory_slot:
		slot.action_inventory = value
		

func dragged_slots(act:int):
	
	if dragged_slot == -1:
		if inventory.slots[act].item != null:
			dragged_slot = act
			temporal_dragged.visible = true
			temporal_icon.texture = inventory.slots[act].item.icono
			temporal_label.text =  str(inventory.slots[act].cant)
			set_process(true)
			return
	elif dragged_slot != -1:
		set_process(false)
		temporal_dragged.visible = false
		inventory.move_slot(dragged_slot,act)
		dragged_slot = -1

func _process(delta) -> void:
	if dragged_slot != -1 and inventory_open == true:
		temporal_dragged.position = get_global_mouse_position()
	else: 
		temporal_dragged.visible = false
