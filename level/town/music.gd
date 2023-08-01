extends Node

@export var fade_duration: float = 1.0

var current_main_theme: AudioStreamPlayer
var currently_playing: AudioStreamPlayer
var hunter_playing: bool = false
var hunters: int = 0

@onready var bgm_village: AudioStreamPlayer = $bgm_village
@onready var bgm_house: AudioStreamPlayer = $bgm_house
@onready var bgm_forest: AudioStreamPlayer = $bgm_forest
@onready var bgm_hunter: AudioStreamPlayer = $bgm_hunter


func _ready() -> void:
	current_main_theme = bgm_forest
	Globals.hunter_saw_player.connect(on_hunter_saw_player)
	Globals.hunter_lost_player.connect(on_hunter_lost_player)


func on_hunter_saw_player() -> void:
	hunters += 1

	if hunter_playing:
		return
		
	hunter_playing = true
	fade(currently_playing, bgm_hunter, fade_duration, true)


func on_hunter_lost_player() -> void:
	hunters -= 1
	#if hunters == 0: # ToDo: Fix
	if true:
		hunter_playing = false
		fade(bgm_hunter, currently_playing, fade_duration, true)


func _on_forest_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	if not currently_playing == bgm_village:
		return
	
	currently_playing = bgm_forest
	current_main_theme = bgm_forest

	if not hunter_playing:
		fade(bgm_village, bgm_forest, fade_duration)


func _on_forest_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	currently_playing = bgm_village
	current_main_theme = bgm_village
	
	if not hunter_playing:
		fade(bgm_forest, bgm_village, fade_duration)


func _on_house_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
		
	currently_playing = bgm_house
	
	if not hunter_playing:
		fade(current_main_theme, bgm_house, fade_duration, true)


func _on_house_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	currently_playing = current_main_theme
	
	if not hunter_playing:
		fade(bgm_house, current_main_theme, fade_duration, true)


func fade(from: AudioStreamPlayer, to: AudioStreamPlayer, duration: float, cross_fade: bool = false):
	var target_volume = to.volume_db
	to.volume_db = -30.0
	
	if from != null and cross_fade:
		to.play(from.get_playback_position())
		
	else:
		to.play()
	
	var tween = create_tween()
	tween.tween_property(to, "volume_db", target_volume, duration)
	if from != null:
		var original_volume = from.volume_db
		tween.parallel().tween_property(from, "volume_db", -30.0, duration)
		tween.tween_callback(func(): from.stop())
		tween.tween_property(from, "volume_db", original_volume, 0.0)
