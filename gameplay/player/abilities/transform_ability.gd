extends Node


@export var speed: float = 160.0

var active: bool = false
var last_direction: Vector2 = Vector2.RIGHT

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var default_speed: float = player.speed


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ability_butterfly"):
		if active:
			disable_butterfly()
		
		else:
			enable_butterfly()


func enable_butterfly():
	active = true
	player.butterfly_active = true
	player.speed = speed
	player.sprite.play("butterfly_right")


func disable_butterfly():
	active = false
	player.butterfly_active = false
	player.speed = default_speed
	player.sprite.play("idle")


func butterfly_animation(delta: float):
	if player.sprite.animation == "butterfly_right" and player.velocity.x < 0:
		player.sprite.play("butterfly_left")
	
	if player.sprite.animation == "butterfly_left" and player.velocity.x > 0:
		player.sprite.play("butterfly_right")
