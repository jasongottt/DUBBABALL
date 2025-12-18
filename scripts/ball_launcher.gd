extends Node2D

@export var ball: RigidBody2D      # drag your ball node here
@export var min_force: float = 400.0
@export var max_force: float = 1200.0
@export var oscillations_per_sec: float = 1.5  # how fast the bar bounces

var charging: bool = false
var power_01: float = 0.0  # 0..1

var direction := 1

func _process(delta: float):
	if charging:
		power_01 += direction * delta * 2  # speed ~ 1.0–3.0
		power_01 = clamp(power_01, 0.0, 1.0)

		if power_01 == 1.0 or power_01 == 0.0:
			direction *= -1  # bounce
		$ProgressBar.value = power_01 * $ProgressBar.max_value
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space") and not charging and not ball.gone:
		charging = true
		self.show()
	elif event.is_action_released("space") and charging and not ball.gone:
		charging = false
		self.hide()
		launch_ball()

func launch_ball() -> void:
	if not is_instance_valid(ball):
		return
	var force = lerp(min_force, max_force, power_01)
	# Pinball usually shoots up, so negative Y
	var impulse := Vector2(0, -force)
	# Godot 4: apply_impulse at the center
	ball.apply_impulse(impulse)
	# Optional: reset bar after launch
	$ProgressBar.value = 0
	power_01 = 0.0
	ball.gone = true 
