extends Node
class_name PlayerState

signal change_state(next_state)

@export var next_state: Array[PlayerState]
var parent: Player

func _ready():
	parent = get_parent().get_parent()

# TO BE OVERRIDEN
func do_something():
	pass

func next(next_state):
	emit_signal("change_state", next_state)
