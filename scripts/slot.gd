"""
SCENE INI FUNGSINYA SEBAGAI SLOTS DI DALAM INVENTORY
"""

extends TextureRect
class_name Slot

signal slot_entered(slot)
signal slot_exited(slot)

var ID
var is_hovering:=false
enum Status {DEFAULT, TAKEN, FREE}
var state := Status.DEFAULT:
	set(new_status):
		state = new_status
		set_color(state)
var item_stored = null

func _on_mouse_entered():
	if not is_hovering:
		is_hovering = true
		emit_signal("slot_entered",self)

func _on_mouse_exited():
	if is_hovering:
		#print("exited", self)
		is_hovering = false
		emit_signal("slot_exited",self)

func set_color(state):
	match state:
		Status.TAKEN:
			%status.visible=true
			%status.color = Color(Color.CRIMSON)
		Status.DEFAULT:
			%status.visible=false
		Status.FREE:
			%status.visible=true
			%status.color = Color(Color.AQUAMARINE)
