extends Control

signal pattern_cleared()
signal pattern_selected(pattern)
signal guide_selected(pattern)

var unlocked_colors = []
var buttongroup = ButtonGroup.new()
var PatternSelectControl = preload("res://scenes/ui/PatternSelectControl.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_pattern(pattern):
	for c in pattern.colors:
		if not unlocked_colors.has(c):
			return false
	return true

func add_pattern(pattern):
	var l = PatternSelectControl.instance()
	l.pattern = pattern
	l.connect("guide_selected", self, "_on_PatternSelect_guide_selected")
	l.visible = show_pattern(pattern)
	$VBoxContainer.add_child(l)
	
func add_color(color):
	unlocked_colors.append(color)
	for pc in $VBoxContainer.get_children():
		pc.visible = show_pattern(pc.pattern)
	
func _on_PatternSelect_guide_selected(pattern):
	emit_signal("guide_selected", pattern)

