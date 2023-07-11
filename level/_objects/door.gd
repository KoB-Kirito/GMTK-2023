@tool
extends StaticBody2D


@export var open: bool = false
@export var player_can_open: bool = true
@export var auto_closes: bool = true

var player_nearby: bool = false

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var interaction_collision: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var snd_open: AudioStreamPlayer2D = $snd_open
@onready var snd_close: AudioStreamPlayer2D = $snd_close
@onready var auto_close_timer: Timer = $AutoCloseTimer
@onready var open_timer: Timer = $OpenTimer


func _ready() -> void:
	update_state()


func _unhandled_key_input(event: InputEvent) -> void:
	# ignore input door is not interactable
	if not player_can_open:
		return
	
	# ignore input if player is not close
	if not player_nearby:
		return
	
	# ignore if already open
	if open:
		return
	
	if event.is_action_pressed("interact"):
		# open door
		sprite.play("open")
		snd_open.play()
		open = true
		open_timer.start()


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_nearby = true
		auto_close_timer.stop()


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_nearby = false
		
		if open and auto_closes:
			# close door after some time
			auto_close_timer.start()


func _on_auto_close_timer_timeout() -> void:
	# close door
	sprite.play("close")
	snd_close.play()
	collision.set_deferred("disabled", false)
	open = false


func _on_open_timer_timeout() -> void:
	# disable collision after some time
	collision.set_deferred("disabled", true)


func update_state():
	# set open state
	if open and sprite.animation != "open":
		sprite.play("opened")
		collision.set_deferred("disabled", true)
		
	elif not open and sprite.animation != "close":
		sprite.play("closed")
		collision.set_deferred("disabled", false)
	
	# set player_can_open
	if player_can_open:
		interaction_collision.set_deferred("disabled", false)
		
	else:
		interaction_collision.set_deferred("disabled", true)


#### Editor
func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_PRE_SAVE:
		update_state()
