extends Area2D


## Scene that should be loaded
@export_file("*.tscn") var scene_path: String
## If enabled player entering the area triggers the teleport
@export var touch: bool = true 


func _on_body_entered(body: Node2D) -> void:
	if not touch:
		return
	
	if not body is Player:
		return
	
	get_tree().change_scene_to_file(scene_path)


# ToDo: add ability to activate with interacting (door, etc)
