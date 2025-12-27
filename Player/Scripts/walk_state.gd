extends PlayerState

func physics_update(delta: float):
	var input_vector = get_input_vector()
	
	if input_vector.length() > 0:
		player.has_target = false  # Cancel click-to-move
		player.velocity = input_vector * player.wasd_speed
		player.move_and_slide()
		player.update_animations()

func get_next_state() -> String:
	var input_vector = get_input_vector()
	
	# If no input, check other states
	if input_vector.length() == 0:
		# Check if mouse is held long enough
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var current_time = Time.get_ticks_msec() / 1000.0
			if player.mouse_press_time > 0 and (current_time - player.mouse_press_time) >= player.click_threshold:
				return "mousefollow"
		
		# Check for click-to-move target
		if player.has_target:
			return "clicktomove"
		
		return "idle"
	
	return ""



