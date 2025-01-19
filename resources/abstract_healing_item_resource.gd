extends ItemResource
class_name HealingItemResource

@export var heal_amount:=1

func consume():
	GlobalEvent.emit_signal("heal", heal_amount)
