extends Node

# Dictionary to store all available states
var states: Dictionary = {}
# Current active state
var current_state: PlayerState = null
# Reference to the player
var player: CharacterBody2D

func _ready():
	# Get reference to the player (parent node)
	player = get_parent() as CharacterBody2D
	if not player:
		push_error("PlayerStateMachine: Parent is not a CharacterBody2D")
		return
	
	# Initialize states from children
	init_state_machine()

# Initialize states from child nodes
func init_state_machine() -> void:
	# Get all child nodes that are PlayerState instances
	for child in get_children():
		if child is PlayerState:
			var state_name = child.name.to_lower()
			child.player = player
			states[state_name] = child
	
	if states.is_empty():
		push_error("PlayerStateMachine: No state nodes found as children")
		return
	
	# Start with idle state (or first state if idle doesn't exist)
	if states.has("idle"):
		change_state("idle")
	else:
		# Start with first available state
		var first_state = states.keys()[0]
		change_state(first_state)

# Change to a new state
func change_state(new_state_name: String) -> void:
	new_state_name = new_state_name.to_lower()
	
	if not states.has(new_state_name):
		push_error("State '%s' not found in state machine" % new_state_name)
		return
	
	# Exit current state
	if current_state:
		current_state.exit()
	
	# Enter new state
	current_state = states[new_state_name]
	current_state.enter()

func _process(delta: float):
	if current_state:
		current_state.update(delta)
		
		# Check for state transitions
		var next_state = current_state.get_next_state()
		if next_state != "":
			change_state(next_state)

func _physics_process(delta: float):
	if current_state:
		current_state.physics_update(delta)
		
		# Check for state transitions after physics update
		var next_state = current_state.get_next_state()
		if next_state != "":
			change_state(next_state)

func _input(event: InputEvent):
	# Handle mouse input for all states
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Button pressed - record the time and position
				player.mouse_press_time = Time.get_ticks_msec() / 1000.0
				player.mouse_press_position = player.get_global_mouse_position()
			else:
				# Button released - check if it was a quick click
				if player.mouse_press_time > 0:
					var press_duration = (Time.get_ticks_msec() / 1000.0) - player.mouse_press_time
					if press_duration < player.click_threshold:
						# It was a quick click - set target position to where it was clicked
						player.target_position = player.mouse_press_position
						player.has_target = true
					player.mouse_press_time = -1.0
	
	# Pass input to current state
	if current_state:
		current_state.handle_input(event)
