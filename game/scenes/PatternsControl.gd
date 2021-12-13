extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_pattern(pattern):
	var l = Label.new()
	if not pattern.unlocked:
		l.text = "???"
	else:
		l.text = pattern.pattern_name[0]
	pattern.connect("unlocked", self, "_on_Pattern_unlocked", [l, pattern])
	# TODO connect the unlocked signal and active the button or something
	$VBoxContainer.add_child(l)

func _on_Pattern_unlocked(control, pattern):
	print_debug("unlocked")
	control.text = pattern.pattern_name[0]
	control.modulate = Color(0, 1, 0)
