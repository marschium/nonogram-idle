extends Control

signal pattern_cleared(pattern)
signal pattern_selected(pattern)
signal guide_selected(pattern)
signal guide_cleared()

var cheat = true
var unlocked_colors = []

var PatternSelectControl = preload("res://scenes/ui/PatternSelectControl.tscn")
var ActivePatternControl = preload("res://scenes/ui/ActivePatternControl.tscn")

onready var pattern_select_vbox = $VBoxContainer/VBoxContainer/PatternSelectVBoxContainer
onready var active_pattern_container = $VBoxContainer/ActivePatternVBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	if cheat:
		enable_autoclick()

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
	l.visible = show_pattern(pattern)
	pattern_select_vbox.add_child(l)
	
func enable_autoclick():
	for pc in pattern_select_vbox.get_children():
		pc.enable_autoclick()
	
func add_color(color):
	unlocked_colors.append(color)
	for pc in pattern_select_vbox.get_children():
		pc.visible = show_pattern(pc.pattern)


func set_current_active(pattern):
	for c in active_pattern_container.get_children():
		if c.pattern == pattern:
			c.mark_active()
		else:
			c.mark_inactive()


func _on_PatternSelect_guide_selected(pattern):
	emit_signal("guide_selected", pattern)

func _on_PatternSelect_set_selected(pattern):	
	if not pattern.unlocked and not cheat:
		return	
	for c in active_pattern_container.get_children():
		if c.pattern == pattern:
			return
	
	emit_signal("pattern_selected", pattern)
	var b = ActivePatternControl.instance()
	b.pattern = pattern
	b.connect("removed", self, "_on_ActivePatternControl_removed", [pattern])
	active_pattern_container.add_child(b)

func _on_Button_pressed():
	emit_signal("guide_cleared")
	
func _on_ActivePatternControl_removed(pattern):
	emit_signal("pattern_cleared", pattern)
	
