extends Control

signal pattern_cleared(pattern)
signal pattern_selected(pattern)
signal guide_selected(pattern)
signal guide_cleared()

var unlocked_colors = []
var buttongroup = ButtonGroup.new()
var PatternSelectControl = preload("res://scenes/ui/PatternSelectControl.tscn")

onready var pattern_select_vbox = $VBoxContainer/PatternSelectVBoxContainer
onready var active_pattern_label = $VBoxContainer/ActivePatternLabel

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
	l.connect("set_selected", self, "_on_PatternSelect_set_selected")
	l.connect("set_deselected", self, "_on_PatternSelect_set_deselected")
	l.visible = show_pattern(pattern)
	pattern_select_vbox.add_child(l)
	
func add_color(color):
	unlocked_colors.append(color)
	for pc in pattern_select_vbox.get_children():
		pc.visible = show_pattern(pc.pattern)
	
func _on_PatternSelect_guide_selected(pattern):
	active_pattern_label.text = "Guide: %s" % pattern.pattern_name
	emit_signal("guide_selected", pattern)

func _on_PatternSelect_set_selected(pattern):
	# TODO only if unlocked
	active_pattern_label.text = "Set: %s" % pattern.pattern_name
	emit_signal("pattern_selected", pattern)
	var b = Button.new()
	b.text = "Clear %s" % [pattern.pattern_name]
	b.connect("pressed", self, "_on_Button3_pressed", [pattern])
	$VBoxContainer.add_child(b)
	
func _on_PatternSelect_set_deselected(pattern):
	emit_signal("pattern_cleared", pattern)

func _on_Button_pressed():
	emit_signal("guide_cleared")

func _on_Button2_pressed():
	emit_signal("pattern_cleared", null) # TODO
	
func _on_Button3_pressed(pattern):
	emit_signal("pattern_cleared", pattern)
	
