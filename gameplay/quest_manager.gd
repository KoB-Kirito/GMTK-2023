extends Node
## Handles the quest to heal all ill npcs


@export var ill_npcs: int
@export var required_reputation: int

var ending_enabled: bool = false


func _ready() -> void:
	Globals.npc_healed.connect(on_npc_healed)


func on_npc_healed():
	ill_npcs -= 1
	print("npc healed ", ill_npcs, " left")
	if ill_npcs <= 0:
		ending_enabled = true
		%EndTimer.start()


func _on_end_area_body_entered(body: Node2D) -> void:
	if not ending_enabled:
		return
	
	if body is Player:
		Dialogic.timeline_ended.connect(on_timeline_ended)
		if Dialogic.VAR.reputation < required_reputation:
			Dialogic.start("bad_end")
		else:
			Dialogic.start("good_end")


func on_timeline_ended():
	if Dialogic.VAR.reputation < required_reputation:
		%LevelchangeFadeOut_GameOver.start()
	else:
		%LevelchangeFadeOut_GameOver.start("res://level/end/end_screen.tscn")


func _on_end_timer_timeout() -> void:
	Dialogic.start("all_healed")
