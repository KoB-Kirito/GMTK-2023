@tool
@icon("res://gameplay/npcs/hunter/patrol_path.svg")
class_name PatrolPath
extends Node2D


const GRID_SIZE: float = 16

@export var cycle: bool = true

var points: Array[PatrolPoint]


func _ready() -> void:
	for child in get_children():
		if child is PatrolPoint:
			points.append(child)


## editor only
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_POST_SAVE, NOTIFICATION_CHILD_ORDER_CHANGED:
			update_configuration_warnings()
			queue_redraw()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	if get_child_count() == 0:
		warnings.append("A PatrolPath needs PatrolPathPoints as children to function")
		
	else:
		for child in get_children():
			if not child is PatrolPoint:
				warnings.append("Children of a PatrolPath must be of type PatrolPathPoint")
				break
	
	return warnings


func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	
	if get_child_count() == 0:
		return
	
	var vertexes: PackedVector2Array
	var i: int = 0
	for child in get_children():
		i += 1
		draw_char(SystemFont.new(), child.global_position + Vector2(2, 1), str(i), 10)
		draw_rect(Rect2(child.global_position - Vector2(GRID_SIZE / 2.0, GRID_SIZE / 2.0), Vector2(GRID_SIZE, GRID_SIZE)), Color("ff000099"), false)
		vertexes.append(child.global_position)
	
	if cycle:
		vertexes.append(vertexes[0])
	
	draw_polyline(vertexes, Color("ffffff99"))