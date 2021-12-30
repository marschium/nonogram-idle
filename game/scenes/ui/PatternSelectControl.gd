extends Control

signal guide_selected(pattern)
signal set_selected(pattern)

var pattern = null
var autoclick_enabled = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func enable_autoclick():
	autoclick_enabled = true
	if pattern.unlocked:
		$VBoxContainer/HBoxContainer/SetButton.disabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO only show set if unlocked
	if pattern == null:
		return
	$VBoxContainer/HBoxContainer/SetButton.disabled = true
	pattern.connect("unlocked", self, "_on_Pattern_unlocked")
	if pattern.unlocked:
		# TODO only enable auto click button if auto clicker upgrade purchased
		$VBoxContainer/NameLabel.text = pattern.pattern_name
		$VBoxContainer/HBoxContainer/SetButton.disabled = !autoclick_enabled


func force_toggle_set_button(pressed):
	$VBoxContainer/HBoxContainer/SetButton.pressed = pressed


func _on_Pattern_unlocked():	
	$VBoxContainer/HBoxContainer/SetButton.disabled = !autoclick_enabled
	$VBoxContainer/NameLabel.text = pattern.pattern_name
	$VBoxContainer/NameLabel.modulate = Color(0, 1, 0)


func _on_SetButton_pressed():	
	emit_signal("set_selected", pattern)

func _on_GuideButton_pressed():
	emit_signal("guide_selected", pattern)
