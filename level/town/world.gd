extends Node2D


func _ready() -> void:
	Globals.game_over.connect(on_game_over)


func _on_levelchange_fade_in_transition_finished() -> void:
	Dialogic.start("intro2")


func on_game_over():
	%LevelchangeFadeOut_GameOver.start()
