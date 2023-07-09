extends Node2D

var oneshot: bool = false

func _on_area_2d_body_entered(body):
	if not body is Player:
		return
	
	if oneshot:
		return
	oneshot = true
	
	Dialogic.start("blacksmith")
