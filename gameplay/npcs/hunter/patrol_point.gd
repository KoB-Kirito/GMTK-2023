@tool
@icon("res://gameplay/npcs/hunter/patrol_point.svg")
class_name PatrolPoint
extends Node2D


const GRID_SIZE: int = 16

@export var data: PatrolPointData


## editor only
func _ready() -> void:
	if Engine.is_editor_hint():
		set_notify_transform(true)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_PRE_SAVE:
			align_to_grid()
		
		NOTIFICATION_EDITOR_POST_SAVE:
			update_configuration_warnings()
		
		NOTIFICATION_TRANSFORM_CHANGED:
			var path = get_parent()
			if path != null:
				path.queue_redraw()


func align_to_grid():
	if GRID_SIZE <= 0:
		return
	
	var half_grid = (GRID_SIZE / 2.0)
	var offset = fmod(position.x + half_grid, GRID_SIZE)
	if offset < half_grid:
		position.x -= offset
	else:
		position.x += GRID_SIZE - offset
	
	offset = fmod(position.y + half_grid, GRID_SIZE)
	if offset < half_grid:
		position.y -= offset
	else:
		position.y += GRID_SIZE - offset


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	var parent = get_parent()
	if parent == null or not parent is PatrolPath:
		warnings.append("A PatrolPathPoint must be a children of a PatrolPath")
	
	return warnings
