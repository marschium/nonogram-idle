extends Control

signal autoclick_toggled(enabled)
signal pattern_toggled(enabled, pattern)
signal guide_toggled(enabled, pattern)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enable_autoclick():
	# TODO reveal panel
	$VBoxContainer/AutoclickerControl.reveal()
	$VBoxContainer/PatternsControl.enable_autoclick()
	
func enable_pattern_select():
	$VBoxContainer/GuideControl.reveal()
	$VBoxContainer/PatternsControl.reveal()
	
func autoclicker_running():
	pass # $VBoxContainer/AutoclickerButton.pressed = true
	
func autoclicker_stopped():
	$VBoxContainer/AutoclickerControl.autoclicker_stopped()
	
func autoclicker_current_pattern(pattern):
	$VBoxContainer/AutoclickerControl.autoclicker_current_pattern(pattern)

func add_pattern(pattern):
	$VBoxContainer/PatternsControl.add_pattern(pattern)
	
func add_color(color):	
	# TODO reveal panel on first
	$VBoxContainer/PatternsControl.add_color(color)	


func _on_PatternsControl_pattern_selected(pattern):
	if not pattern.unlocked:
		return	
	$VBoxContainer/AutoclickerControl.add_pattern(pattern)
	emit_signal("pattern_toggled", true, pattern)


func _on_PatternsControl_guide_selected(pattern):
	$VBoxContainer/GuideControl.set_guide(pattern)
	emit_signal("guide_toggled", true, pattern)
	

func _on_AutoclickerControl_pattern_removed(pattern):
	emit_signal("pattern_toggled", false, pattern)


func _on_AutoclickerControl_play():
	emit_signal("autoclick_toggled", true)


func _on_AutoclickerControl_stop():
	emit_signal("autoclick_toggled", false)


func _on_GuideControl_cleared():	
	emit_signal("guide_toggled", false, null)
