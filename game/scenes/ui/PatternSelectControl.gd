extends Control

signal guide_selected(pattern)
signal set_selected(pattern)

onready var set_button = $PanelContainer/VBoxContainer/HBoxContainer/SetButton
onready var name_label = $PanelContainer/VBoxContainer/NameLabel

var pattern = null
var autoclick_enabled = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func enable_autoclick():
	autoclick_enabled = true
	if pattern.unlocked:
		set_button.disabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO only show set if unlocked
	if pattern == null:
		return
	set_button.disabled = true
	pattern.connect("unlocked", self, "_on_Pattern_unlocked")
	if pattern.unlocked:
		# TODO only enable auto click button if auto clicker upgrade purchased
		name_label.text = pattern.pattern_name
		set_button.disabled = !autoclick_enabled


func force_toggle_set_button(pressed):
	set_button.pressed = pressed


func _on_Pattern_unlocked():	
	set_button.disabled = !autoclick_enabled
	name_label.text = pattern.pattern_name
	name_label.modulate = Color(0, 1, 0)


func _on_SetButton_pressed():	
	emit_signal("set_selected", pattern)

func _on_GuideButton_pressed():
	emit_signal("guide_selected", pattern)
