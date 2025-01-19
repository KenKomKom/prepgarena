"""
SCENE INI FUNGSINYA SEBAGAI DISPLAY GAMBAR ITEM YANG LAGI DIPEGANG SAMA MOUSE / YG TAMPIL
DI INVENTORY
"""

extends Node2D
class_name  Item

@onready var image = $TextureRect

var item_id : int
var item_grids :=[]
var selected = false
var grid_anchor = null

func _process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25*delta)

func load_item(a_id):
	var icon_path = "res://assets/" + DataHandler.item_data[str(a_id)]['name'] + ".png"
	var to_be_loaded = load(icon_path)
	image.texture = to_be_loaded
	image.custom_minimum_size = Vector2(45*image.texture.get_width()/500, 45*image.texture.get_height()/500)
	for grid in DataHandler.item_grid_data[str(a_id)]:
		var convert_array:=[]
		for i in grid:
			convert_array.push_back(int(i))
		item_grids.append(convert_array)

func rotate_item():
	for grid in item_grids:
		var temp = grid[0]
		grid[0] = -grid[1]
		grid[1] = temp
	var temp_deg = rotation_degrees
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rotation_degrees", temp_deg+90, 0.15)
	await tween.finished
	if rotation_degrees>=360:
		rotation_degrees=0

func snap_to(dest: Vector2):
	var tween = get_tree().create_tween()
	if int(rotation_degrees) % 180==0:
		dest += image.size/2
	else:
		var temp_xy_switch = Vector2(image.size.y,image.size.x)
		dest+=temp_xy_switch/2
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", dest, 0.15)
	selected = false
