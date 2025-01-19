extends PlayerState

func do_something():
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		parent.velocity = direction * parent.SPEED
	else:
		if direction.x==0:
			parent.velocity.x = move_toward(parent.velocity.x, 0, parent.SPEED)
		if direction.y==0:
			parent.velocity.y = move_toward(parent.velocity.y, 0, parent.SPEED)
	parent.move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		next(next_state[0])

