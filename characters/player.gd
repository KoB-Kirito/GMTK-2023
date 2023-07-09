class_name Player
extends CharacterBody2D


@export var speed := 80.0

var butterfly_active: bool = false

@onready var butterfly_ability: Node = $Abilities/TransformAbility
@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	# to hide the menu in level editor
	$MenuLayer.visible = true
	
	# enables dialogic pause
	#Globals.enable_pause()
	
	Dialogic.start("intro2")


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
	var x_input := Input.get_axis("move_left", "move_right")
	if x_input:
		velocity.x = x_input * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	var y_input := Input.get_axis("move_up", "move_down")
	if y_input:
		velocity.y = y_input * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	move_and_slide()
