extends PlayerState

func physics_update(delta: float):
	# Stay idle - stop movement
	player.velocity = Vector2.ZERO
	player.update_animations()

func get_next_state() -> String:
	var input_vector = get_input_vector()
	
	# WASD/Controller input (takes priority)
	if input_vector.length() > 0:
		return "walk"
	
	# Mouse button held - check if held long enough
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var current_time = Time.get_ticks_msec() / 1000.0
		if player.mouse_press_time > 0 and (current_time - player.mouse_press_time) >= player.click_threshold:
			return "mousefollow"
	
	# Has click-to-move target
	if player.has_target:
		return "clicktomove"
	
	return ""



