extends Control

signal removed()

var pattern = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/Label.text = pattern.pattern_name
	mark_inactive()

func _on_Button_pressed():
	emit_signal("removed")
	queue_free()

func mark_inactive():
	$HBoxContainer/Label.modulate = Color(0.5, 0.5, 0.5)

func mark_active():
	$HBoxContainer/Label.modulate = Color(0.1, 1.0, 0.1)
