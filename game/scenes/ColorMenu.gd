extends Control

signal color_select(color)

var ColorPickButton = preload("res://scenes/ColorPickButton.tscn")
var revealed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reveal():
	if not revealed:
		visible = true
		revealed = true
		$AnimationPlayer.play("FadeIn")


func add_color(color):
	if color != Color(1, 1, 1, 1):
		reveal()
	var b = ColorPickButton.instance()
	b.modulate = color
	b.connect("pressed", self, "_on_ColorPickButton_pressed", [color])
	$CenterContainer/PanelContainer/VBoxContainer/HBoxContainer.add_child(b)

func _on_ColorPickButton_pressed(color):
	emit_signal("color_select", color)
