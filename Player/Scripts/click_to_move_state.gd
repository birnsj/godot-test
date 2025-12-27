extends PlayerState

func physics_update(delta: float):
	if player.has_target:
		var distance = player.global_position.distance_to(player.target_position)
		
		if distance <= player.arrival_threshold:
			player.velocity = Vector2.ZERO
			player.has_target = false
		else:
			var dynamic_speed = clamp(distance * player.distance_factor, player.min_speed, player.max_speed)
			var direction = (player.target_position - player.global_position).normalized()
			player.velocity = direction * dynamic_speed
			player.move_and_slide()
			player.update_animations()
	else:
		player.velocity = Vector2.ZERO
		player.update_animations()

func get_next_state() -> String:
	# Check for WASD/controller input (takes priority)
	var input_vector = get_input_vector()
	if input_vector.length() > 0:
		return "walk"
	
	# Check if mouse button is held long enough for follow mode
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var current_time = Time.get_ticks_msec() / 1000.0
		if player.mouse_press_time > 0 and (current_time - player.mouse_press_time) >= player.click_threshold:
			return "mousefollow"
	
	# If no target, go to idle
	if not player.has_target:
		return "idle"
	
	return ""



