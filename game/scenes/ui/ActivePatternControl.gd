extends Control

signal removed()

var clicker = null

# Called when the node enters the scene tree for the first time.
func _ready():
    $MarginContainer/HBoxContainer/Label.text = clicker.pattern.pattern_name
    mark_inactive()

func _on_Button_pressed():
    emit_signal("removed")
    queue_free()

func mark_inactive():
    $MarginContainer/HBoxContainer/Label.modulate = Color(0.5, 0.5, 0.5)
    $MarginContainer/HBoxContainer/PlayingLabel.visible = false

func mark_active():
    $MarginContainer/HBoxContainer/Label.modulate = Color(0.1, 1.0, 0.1)
    $MarginContainer/HBoxContainer/PlayingLabel.visible = true
