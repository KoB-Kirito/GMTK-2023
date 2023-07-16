@tool
extends Node

@onready var autoadvance_timer := Timer.new()
@onready var safety_timer := Timer.new()

signal dialogic_action()

################################################################################
## 						INPUT
################################################################################
func _input(event:InputEvent) -> void:
	if Input.is_action_just_pressed(ProjectSettings.get_setting('dialogic/text/input_action', 'dialogic_default_action')):
		# only allow inputs every 0.8 seconds
		if safety_timer.time_left > 0.0:
			return
		safety_timer.start(0.8)
			
		if Dialogic.current_state == Dialogic.states.IDLE and Dialogic.Text.can_manual_advance():
			Dialogic.handle_next_event()
			autoadvance_timer.stop()
		
		elif Dialogic.current_state == Dialogic.states.SHOWING_TEXT and Dialogic.Text.can_skip():
			Dialogic.Text.skip_text_animation()
		
		dialogic_action.emit()


####################################################################################################
##								AUTO-ADVANCING
####################################################################################################
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Dialogic.Text.text_finished.connect(_on_text_finished)
	add_child(autoadvance_timer)
	autoadvance_timer.one_shot = true
	autoadvance_timer.timeout.connect(_on_autoadvance_timer_timeout)
	add_child(safety_timer)
	safety_timer.one_shot = true
	safety_timer.process_mode = Node.PROCESS_MODE_ALWAYS


func _on_text_finished(info:Dictionary) -> void:
	if Dialogic.Text.should_autoadvance():
		autoadvance_timer.start(Dialogic.Text.get_autoadvance_time())


func _on_autoadvance_timer_timeout() -> void:
	Dialogic.handle_next_event()


func is_autoadvancing() -> bool:
	return !autoadvance_timer.is_stopped()


func get_autoadvance_time_left() -> float:
	return autoadvance_timer.time_left


func pause() -> void:
	autoadvance_timer.paused = true

func resume() -> void:
	autoadvance_timer.paused = false
