extends Control

signal pattern_selected(pattern)
signal guide_selected(pattern)

export var Upgrades : NodePath = ""

var unlocked_colors = []
var upgrades = null

var PatternSelectControl = preload("res://scenes/ui/PatternSelectControl.tscn")

onready var pattern_select_vbox = $VBoxContainer/ScrollContainer/PatternSelectVBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	upgrades = get_node(Upgrades)
	upgrades.connect("color_active", self, "_on_Upgrades_color_active")

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
	
func _on_Upgrades_color_active(color):
	unlocked_colors.append(color)
	for pc in pattern_select_vbox.get_children():
		pc.visible = show_pattern(pc.pattern)
		
func reveal():
	$AnimationPlayer.play("FadeIn")
	visible = true

func _on_PatternSelect_guide_selected(pattern):
	emit_signal("guide_selected", pattern)

func _on_PatternSelect_set_selected(pattern):
	emit_signal("pattern_selected", pattern)
