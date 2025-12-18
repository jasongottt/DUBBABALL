extends StaticBody2D

@export var worth: int = 1000
@export var kick_strength: float = 1000.0   # tune to taste
@export var min_kick: float = 800.0        # guarantees a satisfying pop
@onready var sense_area: Area2D = $Area2D
@onready var cooldown: Timer = $Area2D/Timer
@onready var golb = $"/root/global"
var idle = preload("res://sprites/orb.png")
var bumped = preload("res://sprites/bumped.png")

func _ready():
	cooldown.timeout.connect(_on_timer_timeout)
	sense_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if cooldown.time_left > 0.0:  # avoid multiple impulses while overlapping
		return
	if body is RigidBody2D:
		golb.score += worth
		print(golb.score)
		$Area2D/Sprite2D.texture = bumped
		var dir = (body.global_position - global_position).normalized()
		#var approach = max(0.0, dir.dot((body as RigidBody2D).linear_velocity.normalized()))
		#var strength = max(min_kick, kick_strength * (0.5 + 0.5 * approach))
		(body).apply_impulse(dir * kick_strength)
		cooldown.start()

func _on_timer_timeout():
	$Area2D/Sprite2D.texture = idle
