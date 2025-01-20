"""
Cara pake ini scene:
	Jadiin child scene yg bisa interact
	kasih parent-nya method interact()
	kasih scene interactable-nya Collision2D
"""

extends Area2D

@export var hint:='Press F to Interact'
var _interactable := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = hint
	$Label.visible = false

func _process(delta):
	if _interactable and Input.is_action_just_pressed("f"):
		print("interacted")
		if get_parent().has_method("interact"):
			get_parent().interact()

func _on_body_entered(body):
	if not body is Player:
		return
	_interactable = true
	$Label.visible = true

func _on_body_exited(body):
	if not body is Player:
		return
	_interactable = false
	$Label.visible = false
