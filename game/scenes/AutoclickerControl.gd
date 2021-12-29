extends Control


signal autoclick_toggled(enabled)
signal pattern_toggled(enabled, pattern)
signal guide_toggled(enabled, pattern)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enable_autoclick():
	$VBoxContainer/AutoclickerButton.visible = true
	
func enable_pattern_select():
	$VBoxContainer/PatternsControl.visible = true
	
func autoclicker_running():
	$VBoxContainer/AutoclickerButton.pressed = true
	
func autoclicker_stopped():
	$VBoxContainer/AutoclickerButton.pressed = false
	
func autoclicker_current_pattern(pattern):
	$VBoxContainer/PatternsControl.set_current_active(pattern)

func add_pattern(pattern):
	$VBoxContainer/PatternsControl.add_pattern(pattern)
	
func add_color(color):
	$VBoxContainer/PatternsControl.add_color(color)

func _on_AutoclickerButton_toggled(button_pressed):
	emit_signal("autoclick_toggled", button_pressed)

func _on_PatternsControl_pattern_selected(pattern):	
	emit_signal("pattern_toggled", true, pattern)

func _on_PatternsControl_pattern_cleared(pattern):
	emit_signal("pattern_toggled", false, pattern)

func _on_PatternsControl_guide_selected(pattern):
	emit_signal("guide_toggled", true, pattern)


func _on_PatternsControl_guide_cleared():
	emit_signal("guide_toggled", false, null)
