extends Control

const slot_preload = preload("res://scenes/slot.tscn")
const item_preload = preload("res://scenes/item.tscn")

@onready var inventory_grid = $ColorRect/MarginContainer/VBoxContainer/CenterContainer/GridContainer
@onready var pickable_grid = $pickables/MarginContainer/VBoxContainer/CenterContainer/GridContainer
@onready var col_count = inventory_grid.columns
@onready var col_count_pickable = pickable_grid.columns

var grid_array:=[]
var pickable_array:=[]
var item_held : Item
var current_slot : Slot
var can_place := false
var icon_anchor

func _ready():
	GlobalEvent.connect("tab_pressed", _openclose)
	GlobalEvent.connect("give_item", _give_item)
	for i in range(25):
		_create_slot(0)
	for i in range(16):
		_create_slot(1)

func _openclose():
	visible = not visible
	item_held = null
	current_slot = null

func _give_item(items):
	visible = true
	for item in items:
		for i in range(len(pickable_array)):
			icon_anchor = Vector2(1000,1000)
			var new_item = item_preload.instantiate()
			add_child(new_item)
			new_item.load_item(load("res://resources/healing_potion.tres"))
			await get_tree().create_timer(0.01).timeout
			item_held = new_item
			item_held.selected = true
			var can = check_slot_available(pickable_array[i], 1)
			set_grid_color(pickable_array[i],1)
			if can:
				print(i)
				place_item(pickable_array[i])
				break
			else:
				new_item.queue_free()
			clear_grid()
	item_held = null

func _process(delta):
	if item_held:
		if Input.is_action_just_pressed("rmb"):
			rotate_item()
		if Input.is_action_just_pressed("lmb"):
			place_item(current_slot)
		if Input.is_action_just_pressed("f"):
			consume_item()
	else:
		if Input.is_action_just_pressed("lmb"):
			pick_item()

func _create_slot(type:int):
	var slot := slot_preload.instantiate() as Slot
	slot.type = type
	if type==0:
		slot.ID = grid_array.size()
		inventory_grid.add_child(slot)
		grid_array.append(slot)
	if type==1:
		slot.ID = pickable_array.size()
		pickable_grid.add_child(slot)
		pickable_array.append(slot)
	slot.slot_entered.connect(_on_slot_mouse_entered)
	slot.slot_exited.connect(_on_slot_mouse_exited)

func _on_slot_mouse_entered(slot, type):
	current_slot = slot
	icon_anchor = Vector2(1000,1000)
	if item_held:
		check_slot_available(current_slot, current_slot.type)
		set_grid_color(current_slot, current_slot.type)

func _on_slot_mouse_exited(slot, type):
	current_slot = null
	clear_grid()

func _on_button_button_up():
	var new_item = item_preload.instantiate()
	add_child(new_item)
	new_item.load_item(load("res://resources/healing_potion.tres"))
	new_item.selected = true
	item_held = new_item

func check_slot_available(slot, type):
	if type==0:
		for grid in item_held.item_grids:
			var grid_to_check = slot.ID + grid[0] + grid[1]* col_count
			var line_switch_check = slot.ID % col_count + grid[0] 
			if line_switch_check<0 or line_switch_check >=col_count:
				can_place = false
				return false
			if grid_to_check<0 or grid_to_check>=grid_array.size():
				can_place = false
				return false
			if grid_array[grid_to_check].state == grid_array[grid_to_check].Status.TAKEN:
				can_place = false
				return false
		can_place = true
		return true
	if type==1:
		for grid in item_held.item_grids:
			var grid_to_check = slot.ID + grid[0] + grid[1]* col_count_pickable
			var line_switch_check = slot.ID % col_count_pickable + grid[0] 
			if line_switch_check<0 or line_switch_check >= col_count_pickable:
				can_place = false
				return false
			if grid_to_check<0 or grid_to_check>=pickable_array.size():
				can_place = false
				return false
			if pickable_array[grid_to_check].state == pickable_array[grid_to_check].Status.TAKEN:
				can_place = false
				return false
		can_place = true
		return true

func set_grid_color(slot, type):
	if type==0:
		for grid in item_held.item_grids:
			var grid_to_check = slot.ID + grid[0] + grid[1]* col_count
			var line_switch_check = slot.ID % col_count + grid[0] 
			if line_switch_check<0 or line_switch_check >=col_count:
				continue
			if grid_to_check<0 or grid_to_check>=grid_array.size():
				continue
			if can_place:
				grid_array[grid_to_check].set_color(grid_array[grid_to_check].Status.FREE)
				icon_anchor.x = min(grid[1],icon_anchor.x)
				icon_anchor.y = min(grid[0],icon_anchor.y)
			else:
				grid_array[grid_to_check].set_color(grid_array[grid_to_check].Status.TAKEN)
	else:
		for grid in item_held.item_grids:
			var grid_to_check = slot.ID + grid[0] + grid[1]* col_count_pickable
			var line_switch_check = slot.ID % col_count_pickable + grid[0] 
			if line_switch_check<0 or line_switch_check >=col_count_pickable:
				continue
			if grid_to_check<0 or grid_to_check>=pickable_array.size():
				continue
			if can_place:
				pickable_array[grid_to_check].set_color(pickable_array[grid_to_check].Status.FREE)
				icon_anchor.x = min(grid[1],icon_anchor.x)
				icon_anchor.y = min(grid[0],icon_anchor.y)
			else:
				pickable_array[grid_to_check].set_color(pickable_array[grid_to_check].Status.TAKEN)

func clear_grid():
	for grid in grid_array:
		grid.set_color(grid.Status.DEFAULT)
	for grid in pickable_array:
		grid.set_color(grid.Status.DEFAULT)

func rotate_item():
	item_held.rotate_item()
	clear_grid()
	if current_slot:
		_on_slot_mouse_entered(current_slot, current_slot.type)

func place_item(current_slot):
	if not can_place or not current_slot:
		return
	if current_slot.type==0:
		var calc_grid_id = current_slot.ID + icon_anchor.x*col_count + icon_anchor.y
		item_held.snap_to(grid_array[calc_grid_id].global_position)
	elif current_slot.type==1:
		var calc_grid_id = current_slot.ID + icon_anchor.x*col_count_pickable + icon_anchor.y
		print(calc_grid_id, pickable_array[calc_grid_id].global_position, pickable_array[calc_grid_id])
		item_held.snap_to(pickable_array[calc_grid_id].global_position)
	item_held.grid_anchor = current_slot
	for grid in item_held.item_grids:
		if current_slot.type==0:
			var grid_to_check = current_slot.ID + grid[0] + grid[1]*col_count
			grid_array[grid_to_check].state = grid_array[grid_to_check].Status.TAKEN
			grid_array[grid_to_check].item_stored = item_held
		elif current_slot.type==1:
			var grid_to_check = current_slot.ID + grid[0] + grid[1]*col_count_pickable
			pickable_array[grid_to_check].state = pickable_array[grid_to_check].Status.TAKEN
			pickable_array[grid_to_check].item_stored = item_held
	item_held = null
	clear_grid()

func pick_item():
	if not current_slot or not current_slot.item_stored:
		return
	item_held = current_slot.item_stored
	item_held.selected = true
	for grid in item_held.item_grids:
		if current_slot.type==0:
			var grid_to_check = item_held.grid_anchor.ID + grid[0] + grid[1]*col_count
			grid_array[grid_to_check].state = grid_array[grid_to_check].Status.DEFAULT
			grid_array[grid_to_check].item_stored = null
		elif current_slot.type==1:
			var grid_to_check = item_held.grid_anchor.ID + grid[0] + grid[1]*col_count_pickable
			pickable_array[grid_to_check].state = pickable_array[grid_to_check].Status.DEFAULT
			pickable_array[grid_to_check].item_stored = null
	check_slot_available(current_slot, current_slot.type)
	set_grid_color(current_slot, current_slot.type)

func _drop_item():
	item_held.selected = false
	item_held.queue_free()
	item_held = null

func consume_item():
	item_held.consume_item()
	item_held.queue_free()
	item_held = null
