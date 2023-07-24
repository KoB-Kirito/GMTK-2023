class_name PlayerDetector
extends Area2D
# Detects the player in a 45 degree cone, if view is not blocked by collision


signal player_detected
signal player_lost

var sees_player: bool = false
var player: Player


func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func _physics_process(delta: float) -> void:
	if not %DetectionRay.enabled:
		return
	
	%DetectionRay.look_at(player.global_position)
	
	if sees_player:
		if not %DetectionRay.is_colliding():
			lose_player()
			return
		
		if not %DetectionRay.get_collider() is Player:
			lose_player()
			return
		
	else: # does not see player
		if not %DetectionRay.is_colliding():
			return
		
		if %DetectionRay.get_collider() is Player:
			see_player()


func on_body_entered(body: Node2D) -> void:
	if body is Player:
		if player == null:
			player = body
		
		%DetectionRay.enabled = true


func on_body_exited(body: Node2D) -> void:
	if body is Player:
		%DetectionRay.enabled = false
		lose_player()


func see_player():
	sees_player = true
	player_detected.emit()


func lose_player():
	sees_player = false
	player_lost.emit()
