extends PlayerState

var is_striking=false

# TO BE OVERRIDEN
func do_something():
	if not is_striking:
		print("attack")
		is_striking=true
		$Label.visible=true
		parent.animation_player.play("attack")
		await parent.animation_player.animation_finished
		$Label.visible=false
		is_striking=false
		next(next_state[0])
