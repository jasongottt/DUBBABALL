extends RigidBody2D
@export var rotation_speed: float = 35.0 # Degrees per second
@export var max_rotation_angle: float = 45.0 # Max angle for the flipper
@export var right: bool = true
var target_rotation: float = 0.0

func _physics_process(delta: float) -> void:
	# Check for input to activate the paddle
	if Input.is_action_pressed("right") && right: 
		target_rotation = deg_to_rad(max_rotation_angle)
	elif right:
		target_rotation = deg_to_rad(0) # Return to initial position
		
	if Input.is_action_pressed("left") && !right: 
		target_rotation = deg_to_rad(max_rotation_angle)
	elif !right:
		target_rotation = deg_to_rad(0) # Return to initial position

	var current_rotation = rotation
	var new_rotation = lerp_angle(current_rotation, target_rotation, rotation_speed * delta)
	
	# Apply the rotation
	set_rotation(new_rotation)
