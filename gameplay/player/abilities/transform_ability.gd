extends Node


@export var speed: float = 160.0
@export var progress: TextureProgressBar

var active: bool = false
var last_direction: Vector2 = Vector2.RIGHT

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var default_speed: float = player.speed


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ability_butterfly"):
		if active:
			disable_butterfly()
			return
		
		if progress.value < 100.0:
			progress.play_deny_animation()
			return
		
		enable_butterfly()


func _process(delta: float) -> void:
	if active:
		# stop butterfly if time is up
		if progress.value <= 0.0:
			disable_butterfly()
			progress.value = 0.0
			return
		
		# lower amount while active
		progress.value -= 20.0 * delta
		
	else:
		if progress.value == 100.0:
			return
		
		elif progress.value > 100.0:
			progress.value = 100.0
			return
		
		else:
			# increase amount while inactive
			progress.value += 10.0 * delta


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
