class_name Player
extends CharacterBody2D


@export var speed := 80.0


func _ready() -> void:
	$CanvasLayer.visible = true


func _process(delta: float) -> void:
	animation(delta)


func _physics_process(delta: float) -> void:
	movement(delta)


func animation(_delta: float) -> void:
	if velocity == Vector2.ZERO:
		if %Sprite.animation == "walk_down":
			%Sprite.play("idle")
			
		elif %Sprite.animation == "idle":
			return
			
		else:
			%Sprite.stop()
		
		return
	
	
	if Input.is_action_pressed("move_right"):
		%Sprite.play("walk_right")
		
	elif Input.is_action_pressed("move_down"):
		%Sprite.play("walk_down")
		
	elif Input.is_action_pressed("move_left"):
		%Sprite.play("walk_left")
		
	elif Input.is_action_pressed("move_up"):
		%Sprite.play("walk_up")
		
	else:
		%Sprite.stop()


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
