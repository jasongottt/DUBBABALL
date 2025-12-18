extends Node
@onready var golb = $"/root/global"

func _process(delta):
	$Label.text = "SCORE: " + str(golb.score)
