extends Control

signal pattern_cleared()
signal pattern_selected(pattern)
signal guide_selected(pattern)

var buttongroup = ButtonGroup.new()
var PatternSelectControl = preload("res://scenes/ui/PatternSelectControl.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_pattern(pattern):
	var l = PatternSelectControl.instance()
	l.pattern = pattern
	l.connect("guide_selected", self, "_on_PatternSelect_guide_selected")
	$VBoxContainer.add_child(l)
	
func _on_PatternSelect_guide_selected(pattern):
	emit_signal("guide_selected", pattern)

