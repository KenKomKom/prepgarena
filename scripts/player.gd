extends CharacterBody2D
class_name Player
const SPEED = 200.0
var health:=100

@onready var animation_player := $AnimationPlayer

@export var current_state: PlayerState

func _ready():
	for child in $states.get_children():
		child.connect("change_state",set_current_state)

func _physics_process(delta):
	if Input.is_action_just_pressed("tab"):
		GlobalEvent.emit_signal("tab_pressed")
	current_state.do_something()

func take_damage(damage):
	health-=damage

func set_current_state(next_state):
	current_state = next_state
