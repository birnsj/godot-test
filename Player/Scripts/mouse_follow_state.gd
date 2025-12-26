extends PlayerState

func physics_update(delta: float):
	# Follow cursor mode - we only enter this state if button is held long enough
	player.has_target = false
	var mouse_pos = player.get_global_mouse_position()
	var distance = player.global_position.distance_to(mouse_pos)
	var dynamic_speed = clamp(distance * player.distance_factor, player.min_speed, player.max_speed)
	var direction = (mouse_pos - player.global_position).normalized()
	player.velocity = direction * dynamic_speed
	player.move_and_slide()
	player.update_animations()

func get_next_state() -> String:
	# Check for WASD/controller input (takes priority)
	var input_vector = get_input_vector()
	if input_vector.length() > 0:
		return "walk"
	
	# If mouse button released or not held long enough
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if player.has_target:
			return "clicktomove"
		return "idle"
	else:
		# Check if button is held long enough
		var current_time = Time.get_ticks_msec() / 1000.0
		if player.mouse_press_time > 0 and (current_time - player.mouse_press_time) < player.click_threshold:
			# Button just pressed, transition to clicktomove if there's a target
			if player.has_target:
				return "clicktomove"
			return "idle"
	
	return ""


