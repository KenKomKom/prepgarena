extends Control

const slot_preload = preload("res://scenes/slot.tscn")
const item_preload = preload("res://scenes/item.tscn")

@onready var inventory_grid = $ColorRect/MarginContainer/VBoxContainer/CenterContainer/GridContainer
@onready var col_count = inventory_grid.columns

var grid_array:=[]
var item_held : Item
var current_slot : Slot
var can_place := false:
	set(sat):
		can_place=sat
		print(can_place)
var icon_anchor

func _ready():
	GlobalEvent.connect("tab_pressed", _openclose)
	for i in range(25):
		_create_slot()

func _openclose():
	visible = not visible

func _process(delta):
	if item_held:
		if Input.is_action_just_pressed("rmb"):
			rotate_item()
		if Input.is_action_just_pressed("lmb"):
			place_item()
	else:
		if Input.is_action_just_pressed("lmb"):
			pick_item()

func _create_slot():
	var slot := slot_preload.instantiate() as Slot
	slot.ID = grid_array.size()
	inventory_grid.add_child(slot)
	grid_array.append(slot)
	
	slot.slot_entered.connect(_on_slot_mouse_entered)
	slot.slot_exited.connect(_on_slot_mouse_exited)

func _on_slot_mouse_entered(slot):
	current_slot = slot
	icon_anchor = Vector2(1000,1000)
	if item_held:
		check_slot_available(current_slot)
		set_grid_color(current_slot)

func _on_slot_mouse_exited(slot):
	current_slot = null
	clear_grid()

func _on_button_button_up():
	var new_item = item_preload.instantiate()
	inventory_grid.add_child(new_item)
	new_item.load_item(randi_range(1,4))
	new_item.selected = true
	item_held = new_item

func check_slot_available(slot):
	for grid in item_held.item_grids:
		var grid_to_check = slot.ID + grid[0] + grid[1]* col_count
		var line_switch_check = slot.ID % col_count + grid[0] 
		if line_switch_check<0 or line_switch_check >=col_count:
			can_place = false
			return
		if grid_to_check<0 or grid_to_check>=grid_array.size():
			can_place = false
			return
		if grid_array[grid_to_check].state == grid_array[grid_to_check].Status.TAKEN:
			can_place = false
			return
	can_place = true

func set_grid_color(slot):
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

func clear_grid():
	for grid in grid_array:
		grid.set_color(grid.Status.DEFAULT)

func rotate_item():
	item_held.rotate_item()
	clear_grid()
	if current_slot:
		_on_slot_mouse_entered(current_slot)

func place_item():
	if not can_place or not current_slot:
		return
	var calc_grid_id = current_slot.ID + icon_anchor.x*col_count + icon_anchor.y
	item_held.snap_to(grid_array[calc_grid_id].global_position)
	item_held.grid_anchor = current_slot
	for grid in item_held.item_grids:
		var grid_to_check = current_slot.ID + grid[0] + grid[1]*col_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].Status.TAKEN
		grid_array[grid_to_check].item_stored = item_held
	item_held = null
	clear_grid()

func pick_item():
	if not current_slot or not current_slot.item_stored:
		return
	item_held = current_slot.item_stored
	item_held.selected = true
	for grid in item_held.item_grids:
		var grid_to_check = item_held.grid_anchor.ID + grid[0] + grid[1]*col_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].Status.DEFAULT
		grid_array[grid_to_check].item_stored = null
	check_slot_available(current_slot)
	set_grid_color(current_slot)
