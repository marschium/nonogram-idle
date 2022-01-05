extends PanelContainer

signal pattern_removed(pattern)
signal play()
signal stop()

var ActivePatternControl = preload("res://scenes/ui/ActivePatternControl.tscn")

onready var active_pattern_container = $VBoxContainer/ActivePatternVBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_pattern(pattern):
	for c in active_pattern_container.get_children():
		if c.pattern == pattern:
			return

	var b = ActivePatternControl.instance()
	b.pattern = pattern
	b.connect("removed", self, "_on_ActivePatternControl_removed", [pattern])
	active_pattern_container.add_child(b)
	emit_signal("pattern_toggled", true, pattern)


func autoclicker_current_pattern(pattern):
	for c in active_pattern_container.get_children():
		if c.pattern == pattern:
			c.mark_active()
		else:
			c.mark_inactive()

func _on_ActivePatternControl_removed(pattern):
	emit_signal("pattern_removed", pattern)

func _on_PauseButton_pressed():
	emit_signal("stop")

func _on_PlayButton_pressed():
	emit_signal("play")
