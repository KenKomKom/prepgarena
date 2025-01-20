extends StaticBody2D

func open():
	GlobalEvent.emit_signal("give_item",["res://resources/healing_potion.tres",
	"res://resources/healing_potion.tres"])

func interact():
	open()
