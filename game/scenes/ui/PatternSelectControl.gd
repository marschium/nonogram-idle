extends Control

signal guide_selected(pattern)
signal set_selected(pattern)

var pattern = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if pattern == null:
		return
	pattern.connect("unlocked", self, "_on_Pattern_unlocked")
	if pattern.unlocked:
		$VBoxContainer/NameLabel.text = pattern.pattern_name[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GuideButton_toggled(button_pressed):
	if button_pressed:
		emit_signal("guide_selected", pattern)


func _on_SetButton_toggled(button_pressed):
	if button_pressed:
		emit_signal("set_selected", pattern)


func _on_Pattern_unlocked():	
	$VBoxContainer/NameLabel.text = pattern.pattern_name[0]
	$VBoxContainer/NameLabel.modulate = Color(0, 1, 0)
