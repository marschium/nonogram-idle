extends Control

signal color_select(color)

var ColorPickButton = preload("res://scenes/ColorPickButton.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_color(color):
	var b = ColorPickButton.instance()
	b.modulate = color
	b.connect("pressed", self, "_on_ColorPickButton_pressed", [color])
	$CenterContainer/HBoxContainer.add_child(b)

func _on_ColorPickButton_pressed(color):
	emit_signal("color_select", color)
