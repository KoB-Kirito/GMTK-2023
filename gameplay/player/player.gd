class_name Player
extends CharacterBody2D


@export var speed := 80.0

var butterfly_active: bool = false

@onready var butterfly_ability: Node = $AbilityManager
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision: CollisionShape2D = $CollisionShape2D


func _process(delta: float) -> void:
	animation(delta)


func _physics_process(delta: float) -> void:
	movement(delta)


func animation(delta: float) -> void:
	if butterfly_active:
		butterfly_ability.butterfly_animation(delta)
		return
	
	if velocity == Vector2.ZERO:
		if sprite.animation == "walk_down":
			sprite.play("idle")
			
		elif sprite.animation == "idle":
			return
			
		else:
			sprite.stop()
		
		return
	
	if Input.is_action_pressed("move_right"):
		sprite.play("walk_right")
		
	elif Input.is_action_pressed("move_down"):
		sprite.play("walk_down")
		
	elif Input.is_action_pressed("move_left"):
		sprite.play("walk_left")
		
	elif Input.is_action_pressed("move_up"):
		sprite.play("walk_up")
		
	else:
		sprite.stop()


func movement(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
