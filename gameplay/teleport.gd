extends Area2D


## Scene that should be loaded
@export_file("*.tscn") var scene_path: String
## If enabled player entering the area triggers the teleport
@export var teleport_on_touch: bool = true 

var player_touching: bool = false


func _on_body_entered(body: Node2D) -> void:
	if not teleport_on_touch:
		return
	
	if not body is Player:
		return
	
	get_tree().change_scene_to_file(scene_path)


func _on_detection_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	
	
	pass # Replace with function body.


func _on_detection_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
