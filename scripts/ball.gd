extends RigidBody2D
@export var gone = false;
var start_pos = Vector2(796,456)

func _ready():
	pass
	
func _physics_process(delta):
	pass
		
func _process(delta):
	if Input.is_action_just_pressed("space") && gone:
		print("yurrr")
		
func _integrate_forces(state):
	if Input.is_action_just_released("restart") && gone:
		gone = false;
		state.transform.origin = start_pos
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
