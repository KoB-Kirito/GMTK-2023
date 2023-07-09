extends Node

@onready var bgm_village: AudioStreamPlayer = $bgm_village
@onready var bgm_house: AudioStreamPlayer = $bgm_house
@onready var bgm_forest: AudioStreamPlayer = $bgm_forest


func _on_forest_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	bgm_village.stop()
	bgm_forest.play()


func _on_forest_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	bgm_forest.stop()
	bgm_village.play()


func _on_house_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
		
	bgm_house.play(bgm_village.get_playback_position())
	bgm_village.stop()

func _on_house_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	

	bgm_village.play(bgm_house.get_playback_position())
	bgm_house.stop()
