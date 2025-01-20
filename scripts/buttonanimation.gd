extends Node

@export var from_center : bool = true
@export var hover_scale : Vector2 =Vector2.ONE
@export var time := 0.5
@export var transition_type: Tween.TransitionType

var target : Control
var default_scale : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent()
	call_deferred("set_up")
	target.connect("mouse_entered", on_hover)
	target.connect("mouse_exited", off_hover)

func set_up():
	if from_center:
		target.pivot_offset = target.size/2
	default_scale = target.scale

func on_hover():
	add_tween("scale", hover_scale,time)

func off_hover():
	add_tween("scale", default_scale ,time)

func add_tween(property:String, value, seconds:float):
	if get_tree()!=null:
		var tween= get_tree().create_tween()
		tween.tween_property(target, property, value, seconds).set_trans(transition_type)
