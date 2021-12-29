extends Control

signal removed()

var pattern = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/Label.text = pattern.pattern_name

func _on_Button_pressed():
	emit_signal("removed")
	queue_free()
