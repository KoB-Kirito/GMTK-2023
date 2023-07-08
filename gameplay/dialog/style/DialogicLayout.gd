extends CanvasLayer

const portrait_default_margin: int = 4

@export var portrait_margin: int = 144
@export var animation_duration: float = 0.6


func _ready() -> void:
	Dialogic.Portraits.character_joined.connect(on_character_joined)
	Dialogic.Portraits.character_left.connect(on_character_left)


func on_character_joined(_info: Dictionary):
	var tween = create_tween()
	
	# move text to the right
	tween.tween_method(tween_margin, portrait_default_margin, portrait_margin, animation_duration)
	
	# slide name in
	tween.parallel().tween_property(%NameContainer, "position:x", -40, animation_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# fade name in
	tween.parallel().tween_property(%NameContainer, "modulate", Color(1.0, 1.0, 1.0, 1.0), animation_duration)


func on_character_left(_info: Dictionary):
	var tween = create_tween()
	
	# move text to the left
	tween.tween_method(tween_margin, portrait_margin, portrait_default_margin, animation_duration)

	# slide name in
	tween.parallel().tween_property(%NameContainer, "position:x", -265, animation_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	
	# fade name in
	tween.parallel().tween_property(%NameContainer, "modulate", Color(1.0, 1.0, 1.0, 0.0), animation_duration)


func tween_margin(value: int):
	%TextMargin.add_theme_constant_override("margin_left", value)
