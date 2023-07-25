@tool
@icon("res://gameplay/npcs/patrolling/patrol_point.svg")
class_name PatrolPoint
extends Node2D
# represents one point on a patrol path


const GRID_SIZE: int = 16

## Data for this patrol point. Inherit from PatrolPointData to add more
@export var patrol_data: PatrolPointData



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
		
		NOTIFICATION_DRAG_END:
			# ToDo: why does this not fire? :reeee:
			print("drag ended")



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
	
	if patrol_data != null:
		if !patrol_data.look_right and !patrol_data.look_down and !patrol_data.look_left and !patrol_data.look_up:
			warnings.append("You must enable at least one look direction if set as patrol point")
	
	var parent = get_parent()
	if parent == null or not parent is PatrolPath:
		warnings.append("A PatrolPathPoint must be a children of a PatrolPath")
	
	return warnings
