@tool
class_name PatrolPointData
extends Resource


## If > 0, the unit will use this speed to get TO this point
@export var speed_override: float = 0.0

## How long the unit stops at this point. Has no effect if not used on a PatrolPoint.
@export var stay_duration: float = 0.0:
	set(value):
		stay_duration = value
		notify_property_list_changed()

var look_right: bool = true:
	set(value):
		look_right = value
		notify_property_list_changed()
var look_down: bool = true:
	set(value):
		look_down = value
		notify_property_list_changed()
var look_left: bool = true:
	set(value):
		look_left = value
		notify_property_list_changed()
var look_up: bool = true:
	set(value):
		look_up = value
		notify_property_list_changed()

## How the unit cycles through directions. Only directions enabled above.
var cycle_mode: int = 0:
	set(value):
		cycle_mode = value
		notify_property_list_changed()
## If enabled, random will pick a new direction everytime
var always_new: bool = true

## Minimum duration until direction is cycled, in seconds
var duration_min: float = 2.0:
	set(value):
		duration_min = value
		if duration_max < duration_min:
			duration_max = duration_min
## Maximum duration until direction is cycled, in seconds
var duration_max: float = 4.0:
	set(value):
		duration_max = value
		if duration_min > duration_max:
			duration_min = duration_max



## editor only
func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary]
	
	if stay_duration > 0.0:
		properties.append({
			"name": "Stationary Settings",
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_GROUP,
		})
		properties.append({
			"name": "look_right",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		properties.append({
			"name": "look_down",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		properties.append({
			"name": "look_left",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		properties.append({
			"name": "look_up",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		if [look_right, look_down, look_left, look_up].count(true) > 1:
			properties.append({
			"name": "Cycle Directions",
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_GROUP,
			})
			
			if [look_right, look_down, look_left, look_up].count(true) > 2:
				properties.append({
					"name": "cycle_mode",
					"type": TYPE_INT,
					"usage": PROPERTY_USAGE_DEFAULT,
					"hint": PROPERTY_HINT_ENUM,
					"hint_string": "Clockwise,Counter-clockwise,Random"
				})
				
				if cycle_mode == 2:
					properties.append({
						"name": "always_new",
						"type": TYPE_BOOL,
						"usage": PROPERTY_USAGE_DEFAULT,
					})
			
			properties.append({
				"name": "duration_min",
				"type": TYPE_FLOAT,
				"usage": PROPERTY_USAGE_DEFAULT,
			})
			properties.append({
				"name": "duration_max",
				"type": TYPE_FLOAT,
				"usage": PROPERTY_USAGE_DEFAULT,
			})
	
	return properties
