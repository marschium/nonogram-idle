extends Control

signal guide_selected(pattern)
signal set_selected(pattern)
signal set_deselected(pattern)

var pattern = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO only show set if unlocked
	if pattern == null:
		return
	pattern.connect("unlocked", self, "_on_Pattern_unlocked")
	if pattern.unlocked:
		$VBoxContainer/NameLabel.text = pattern.pattern_name[0]


func force_toggle_set_button(pressed):
	$VBoxContainer/HBoxContainer/SetButton.pressed = pressed

func _on_GuideButton_toggled(button_pressed):
	if button_pressed:
		emit_signal("guide_selected", pattern)


func _on_SetButton_toggled(button_pressed):
	if button_pressed:
		emit_signal("set_selected", pattern)
	else:
		emit_signal("set_deselected", pattern)


func _on_Pattern_unlocked():	
	$VBoxContainer/NameLabel.text = pattern.pattern_name
	$VBoxContainer/NameLabel.modulate = Color(0, 1, 0)


func _on_SetButton_pressed():	
	emit_signal("set_selected", pattern)

func _on_GuideButton_pressed():
	emit_signal("guide_selected", pattern)
