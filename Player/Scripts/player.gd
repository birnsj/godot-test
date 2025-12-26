extends CharacterBody2D

@export var min_speed: float = 25.0
@export var max_speed: float = 200.0
@export var distance_factor: float = 2.5  # Distance in pixels that corresponds to max speed
@export var arrival_threshold: float = 5.0  # Distance at which we consider the target reached
@export var click_threshold: float = 0.2  # Time in seconds to distinguish click from hold
@export var wasd_speed: float = 150.0  # Speed for WASD movement
@export var controller_deadzone: float = 0.2  # Deadzone for controller stick input

var target_position: Vector2 = Vector2.ZERO
var has_target: bool = false
var mouse_press_time: float = -1.0
var mouse_press_position: Vector2 = Vector2.ZERO

@onready var animation_player = $CollisionShape2D/AnimationPlayer
@onready var sprite = $CollisionShape2D/ExamplePlayerSprite
@onready var state_machine = $PlayerStateMachine

var last_direction: String = "down"  # Track last movement direction

func _ready():
	# Initialize with idle animation
	if animation_player and animation_player.has_animation("idle_down"):
		animation_player.play("idle_down")
	
	# State machine will initialize itself in its _ready()

func update_animations():
	if not animation_player:
		return
	
	var is_moving = velocity.length() > 0
	var anim_name: String = ""
	
	if is_moving:
		# Determine direction based on velocity
		var dir = velocity.normalized()
		
		# Use absolute values to determine primary direction
		if abs(dir.x) > abs(dir.y):
			# Horizontal movement (left or right)
			if dir.x > 0:
				last_direction = "right"
				anim_name = "walk_side"
				if sprite:
					sprite.scale.x = abs(sprite.scale.x)  # Face right (positive scale)
			else:
				last_direction = "left"
				anim_name = "walk_side"
				if sprite:
					sprite.scale.x = -abs(sprite.scale.x)  # Face left (negative scale)
		else:
			# Vertical movement (up or down)
			if dir.y > 0:
				last_direction = "down"
				anim_name = "walk_down"
			else:
				last_direction = "up"
				anim_name = "walk_up"
	else:
		# Idle animation based on last direction
		if last_direction == "up":
			anim_name = "idle_up"
		elif last_direction == "down":
			anim_name = "idle_down"
		elif last_direction == "left" or last_direction == "right":
			anim_name = "idle_side"
			# Maintain scale for left/right idle
			if sprite:
				if last_direction == "left":
					sprite.scale.x = -abs(sprite.scale.x)  # Face left
				else:
					sprite.scale.x = abs(sprite.scale.x)  # Face right
		else:
			anim_name = "idle_down"  # Default
	
	# Play animation if it exists and is different from current
	if anim_name != "" and animation_player.has_animation(anim_name):
		if animation_player.current_animation != anim_name:
			animation_player.play(anim_name)
