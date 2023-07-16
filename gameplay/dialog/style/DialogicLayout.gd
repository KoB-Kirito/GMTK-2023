extends CanvasLayer


signal intro_animation_finished

const text_min_margin: int = 4
const intro_animation_duration: float = 0.5
const animation_duration: float = 0.5
const slide_distance: int = 100

var left_name_position: int
var right_name_position: int
var portrait_width: int

var left_character: DialogicCharacter
var right_character: DialogicCharacter


func _ready() -> void:
	# pause game
	get_tree().paused = true
	
	# get current layout
	portrait_width = %LeftPortraitContainer.size.x
	left_name_position = %LeftNameContainer.position.x
	right_name_position = %RightNameContainer.position.x
	
	# set name starting position
	%LeftNameContainer.position.x = left_name_position - slide_distance
	%RightNameContainer.position.x = right_name_position + slide_distance
	%LeftNameContainer.modulate = Color(1.0, 1.0, 1.0, 0.0)
	%RightNameContainer.modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	# set starting text margin
	%TextMargin.add_theme_constant_override("margin_left", text_min_margin)
	%TextMargin.add_theme_constant_override("margin_right", text_min_margin)
	
	Dialogic.Portraits.character_joined.connect(_on_character_joined)
	Dialogic.Portraits.character_left.connect(_on_character_left)
	Dialogic.Text.about_to_show_text.connect(_on_about_to_show_text)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	
	# intro animation
	var textbox_position = %TextContainer.position.y
	%TextContainer.position.y = textbox_position + %TextContainer.size.y
	var tween = create_tween()
	tween.tween_property(%BackgroundFade, "color", Color(0.0, 0.0, 0.0, 0.2), intro_animation_duration)
	tween.parallel().tween_property(%TextContainer, "position:y", textbox_position, intro_animation_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(func(): intro_animation_finished.emit())


func _on_character_joined(info: Dictionary):
	# clear text
	%DialogicNode_DialogText.text = ""
	
	var character = info["character"] as DialogicCharacter
	match info["position_index"]:
		1:
			join_left_character(character)
		
		2:
			join_right_character(character)


func _on_character_left(info: Dictionary):
	# clear text
	%DialogicNode_DialogText.text = ""
	
	var character = info["character"] as DialogicCharacter
	if character == left_character:
		left_character = null
		leave_left_character()
		
	elif character == right_character:
		right_character = null
		leave_right_character()


func _on_about_to_show_text(info: Dictionary):
	var character = info["character"] as DialogicCharacter
	
	if character == null:
		fade_left_character()
		fade_right_character()
		
	elif character == left_character:
		fade_right_character()
		%LeftNameContainer.modulate = Color(1.0, 1.0, 1.0)
		%LeftPortraitContainer.modulate = Color(1.0, 1.0, 1.0)
		
	elif character == right_character:
		fade_left_character()
		%RightNameContainer.modulate = Color(1.0, 1.0, 1.0)
		%RightPortraitContainer.modulate = Color(1.0, 1.0, 1.0)


func _on_timeline_ended():
	get_tree().paused = false


func fade_left_character():
	if left_character != null:
		%LeftNameContainer.modulate = Color(0.5, 0.5, 0.5)
		%LeftPortraitContainer.modulate = Color(0.5, 0.5, 0.5)


func fade_right_character():
	if right_character != null:
		%RightNameContainer.modulate = Color(0.5, 0.5, 0.5)
		%RightPortraitContainer.modulate = Color(0.5, 0.5, 0.5)


func join_left_character(character: DialogicCharacter):
	var layout_already_set = false if left_character == null else true
	left_character = character
	
	# set left label
	%LeftNameLabel.text = left_character.display_name
	%LeftNameLabel.self_modulate = left_character.color
	
	# don't animate again
	if layout_already_set:
		return
	
	# move text right
	%TextMargin.add_theme_constant_override("margin_left", portrait_width)
	
	var tween = create_tween().set_parallel()
	
	# fade name in
	tween.tween_property(%LeftNameContainer, "modulate", Color(1.0, 1.0, 1.0, 1.0), animation_duration)
	
	# slide name in
	tween.tween_property(%LeftNameContainer, "position:x", left_name_position, animation_duration * 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func join_right_character(character: DialogicCharacter):
	var layout_already_set = false if right_character == null else true
	right_character = character
	
	# set right label
	%RightNameLabel.text = right_character.display_name
	%RightNameLabel.self_modulate = right_character.color
	
	# don't animate again
	if layout_already_set:
		return
	
	# move text left
	%TextMargin.add_theme_constant_override("margin_right", portrait_width)
	
	var tween = create_tween().set_parallel()
	
	# fade name in
	tween.tween_property(%RightNameContainer, "modulate", Color(1.0, 1.0, 1.0, 1.0), animation_duration)
	
	# slide name in
	tween.tween_property(%RightNameContainer, "position:x", right_name_position, animation_duration * 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func leave_left_character():
	# move text left
	%TextMargin.add_theme_constant_override("margin_left", text_min_margin)

	var tween = create_tween().set_parallel()
	
	# fade name out
	tween.tween_property(%LeftNameContainer, "modulate", Color(1.0, 1.0, 1.0, 0.0), animation_duration)
	
	# slide name out
	tween.tween_property(%LeftNameContainer, "position:x", left_name_position - slide_distance, animation_duration * 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)


func leave_right_character():
	# move text right
	%TextMargin.add_theme_constant_override("margin_right", text_min_margin)
	
	var tween = create_tween().set_parallel()
	
	# fade name out
	tween.tween_property(%RightNameContainer, "modulate", Color(1.0, 1.0, 1.0, 0.0), animation_duration)
	
	# slide name out
	tween.tween_property(%RightNameContainer, "position:x", right_name_position + slide_distance, animation_duration * 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
