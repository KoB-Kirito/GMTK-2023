#@tool
extends TileMap


@export var player: Player

var elevated: bool = false


func _physics_process(delta: float) -> void:
	check_elevation()


func check_elevation() -> void:
	if player == null:
		return
	
	if elevated and not is_on_elevation_tile():
		lower_player()
		
	elif not elevated and is_on_elevation_tile():
		elevate_player()



func is_on_elevation_tile() -> bool:
	var tile_under := local_to_map(player.position)
	
	# check all layers for custom data
	for layer in get_layers_count() - 1:
		var tile_data = get_cell_tile_data(layer, tile_under)
		
		if tile_data == null:
			continue
		
		# custom data field set in tileset
		if tile_data.get_custom_data("elevation"):
			return true
	
	return false


func elevate_player() -> void:
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(1, false)
	player.set_collision_layer_value(2, true)
	player.set_collision_mask_value(2, true)
	elevated = true


func lower_player() -> void:
	player.set_collision_layer_value(2, false)
	player.set_collision_mask_value(2, false)
	player.set_collision_layer_value(1, true)
	player.set_collision_mask_value(1, true)
	elevated = false


#func _notification(what: int) -> void:
#	if what == NOTIFICATION_EDITOR_POST_SAVE:
#		# removes all missing tiles
#		fix_invalid_tiles()
