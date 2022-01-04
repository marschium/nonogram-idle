extends Control

signal autoclick_toggled(enabled)
signal pattern_toggled(enabled, pattern)
signal guide_toggled(enabled, pattern)

var ActivePatternControl = preload("res://scenes/ui/ActivePatternControl.tscn")
onready var active_pattern_container = $VBoxContainer/PanelContainer/VBoxContainer/ActivePatternVBoxContainer

export var cheat = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enable_autoclick():
	#$VBoxContainer/AutoclickerButton.visible = true
	$VBoxContainer/PatternsControl.enable_autoclick()
	
func enable_pattern_select():
	$VBoxContainer/PatternsControl.visible = true
	
func autoclicker_running():
	pass # $VBoxContainer/AutoclickerButton.pressed = true
	
func autoclicker_stopped():
	pass  # $VBoxContainer/AutoclickerButton.pressed = false
	
func autoclicker_current_pattern(pattern):
	for c in active_pattern_container.get_children():
		if c.pattern == pattern:
			c.mark_active()
		else:
			c.mark_inactive()

func add_pattern(pattern):
	$VBoxContainer/PatternsControl.add_pattern(pattern)
	
func add_color(color):
	$VBoxContainer/PatternsControl.add_color(color)
	

func _on_PatternsControl_pattern_selected(pattern):
	if not pattern.unlocked and not cheat:
		return	
	for c in active_pattern_container.get_children():
		if c.pattern == pattern:
			return

	var b = ActivePatternControl.instance()
	b.pattern = pattern
	b.connect("removed", self, "_on_ActivePatternControl_removed", [pattern])
	active_pattern_container.add_child(b)
	emit_signal("pattern_toggled", true, pattern)

func _on_Button_pressed():
	emit_signal("guide_cleared")
	
func _on_ActivePatternControl_removed(pattern):
	emit_signal("pattern_cleared", pattern)
	emit_signal("pattern_toggled", false, pattern)

func _on_PatternsControl_pattern_cleared(pattern):
	emit_signal("pattern_toggled", false, pattern)

func _on_PatternsControl_guide_selected(pattern):
	emit_signal("guide_toggled", true, pattern)

func _on_PatternsControl_guide_cleared():
	emit_signal("guide_toggled", false, null)

func _on_PlayButton_pressed():	
	emit_signal("autoclick_toggled", true)

func _on_PauseButton_pressed():
	emit_signal("autoclick_toggled", false)
