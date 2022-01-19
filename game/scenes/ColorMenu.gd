extends Control

signal color_select(color)

export var UpgradeNode: NodePath = ""

var ColorPickButton = preload("res://scenes/ColorPickButton.tscn")
var revealed = false
var upgrades = null


# Called when the node enters the scene tree for the first time.
func _ready():
	upgrades = get_node(UpgradeNode)
	upgrades.connect("color_active", self, "_on_Upgrades_color_active")

func reveal():
	if not revealed:
		visible = true
		revealed = true
		$AnimationPlayer.play("FadeIn")


func _on_Upgrades_color_active(color):
	if color != Color(1, 1, 1, 1):
		reveal()
	var b = ColorPickButton.instance()
	b.modulate = color
	b.connect("pressed", self, "_on_ColorPickButton_pressed", [color])
	$CenterContainer/PanelContainer/VBoxContainer/HBoxContainer.add_child(b)

func _on_ColorPickButton_pressed(color):
	emit_signal("color_select", color)
