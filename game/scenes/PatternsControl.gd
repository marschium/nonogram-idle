extends Control

signal pattern_cleared()
signal pattern_selected(pattern)

var buttongroup = ButtonGroup.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_pattern(pattern):
	var l = Button.new()
	l.toggle_mode = true
	l.group = buttongroup
	if not pattern.unlocked:
		l.text = "???"
	else:
		l.text = pattern.pattern_name[0]
	l.connect("toggled", self, "_on_PatternButton_toggled", [l, pattern])
	pattern.connect("unlocked", self, "_on_Pattern_unlocked", [l, pattern])
	# TODO connect the unlocked signal and active the button or something
	$VBoxContainer.add_child(l)
	
func _on_PatternButton_toggled(pressed, control, pattern):
	if pressed:
		if pattern.unlocked:
			emit_signal("pattern_selected", pattern)
		else:			
			control.pressed = false
	else:
		emit_signal("pattern_cleared")

func _on_Pattern_unlocked(control, pattern):
	print_debug("unlocked")
	control.text = pattern.pattern_name[0]
	control.modulate = Color(0, 1, 0)
