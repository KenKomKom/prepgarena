extends Node

var item_data={}
var item_grid_data:={}
var item_data_path = "res://data/items.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data(item_data_path)
	set_item_grid()

func load_data(path):
	if not FileAccess.file_exists(path):
		print("not found")
	var doc = FileAccess.open(path, FileAccess.READ)
	item_data = JSON.parse_string(doc.get_as_text())
	doc.close()

func set_item_grid():
	for item in item_data.keys():
		var temp = []
		for poin in item_data[item]['grid'].split('/'):
			temp.append(poin.split(','))
		item_grid_data[item]=temp
	print(item_grid_data)
