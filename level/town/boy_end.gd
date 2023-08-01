extends Sprite2D

var oneshot: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if oneshot:
			return
		oneshot = true
		
		Dialogic.timeline_ended.connect(on_signal)
		
		Dialogic.start("ending")


func on_signal(argument: String):
	if argument == "end":
		Globals.person_healed.emit()
