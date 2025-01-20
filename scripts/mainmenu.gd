extends CanvasLayer

func _on_start_button_up():
	# TODO JANGAN LUPA GANTI VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
	GameManager.next_level = "res://scenes/abstract_level.tscn"
	get_tree().change_scene_to_file("res://scenes/loadingscreen.tscn")

func _on_credit_button_up():
	pass # Replace with function body.
