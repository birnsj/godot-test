class_name PlayerState
extends Node

# Reference to the player that owns this state
var player: CharacterBody2D

# Called when the state is entered
func enter() -> void:
	pass

# Called when the state is exited
func exit() -> void:
	pass

# Called every frame while in this state
func update(delta: float) -> void:
	pass

# Called every physics frame while in this state
func physics_update(delta: float) -> void:
	pass

# Called when input events occur while in this state
func handle_input(event: InputEvent) -> void:
	pass

# Transition to a new state (returns the name of the new state, or empty string to stay)
func get_next_state() -> String:
	return ""

# Shared helper function to get input vector from WASD/controller
func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	
	# Get WASD input
	if Input.is_key_pressed(KEY_W):
		input_vector.y -= 1
	if Input.is_key_pressed(KEY_S):
		input_vector.y += 1
	if Input.is_key_pressed(KEY_A):
		input_vector.x -= 1
	if Input.is_key_pressed(KEY_D):
		input_vector.x += 1
	
	# Get controller input
	var controller_vector = Vector2.ZERO
	if Input.get_connected_joypads().size() > 0:
		var joypad_id = Input.get_connected_joypads()[0]
		controller_vector = Vector2(
			Input.get_joy_axis(joypad_id, JOY_AXIS_LEFT_X),
			Input.get_joy_axis(joypad_id, JOY_AXIS_LEFT_Y)
		)
		if controller_vector.length() < player.controller_deadzone:
			controller_vector = Vector2.ZERO
	
	# Prefer controller if active
	if controller_vector.length() > player.controller_deadzone:
		input_vector = controller_vector
	else:
		input_vector = input_vector.normalized()
	
	return input_vector
