extends Node

@export var y_hover : int =0
@export var time := 0.5
@export var transition_type: Tween.TransitionType

var target
var default_y

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent()
	call_deferred("set_up")
	target.connect("mouse_entered", on_hover)
	target.connect("mouse_exited", off_hover)
	target.connect("button_down", button_down)

func set_up():
	default_y = get_parent().custom_minimum_size.y

func on_hover():
	#add_tween(get_parent().get_theme_stylebox("hover"), "grow_begin", 10,time)
	#add_tween(get_parent().get_theme_stylebox("hover"), "grow_end", 10,time)
	add_tween(get_parent().get_child(0), "custom_minimum_size:x", 200, time)
	add_tween(get_parent(), "custom_minimum_size:y", default_y+20, time)

func off_hover():
	#add_tween(get_parent().get_theme_stylebox("hover"), "grow_begin", 0,time)
	#add_tween(get_parent().get_theme_stylebox("hover"), "grow_end",0,time)
	add_tween(get_parent().get_child(0), "custom_minimum_size:x", 0, time)
	add_tween(get_parent(), "custom_minimum_size:y", default_y, time)

func button_down():
	add_tween(get_parent().get_child(0), "color", Color(Color.CADET_BLUE), time)

func add_tween(target, property:String, value, seconds:float):
	if get_tree()!=null:
		var tween= get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(target, property, value, seconds).set_trans(transition_type)
