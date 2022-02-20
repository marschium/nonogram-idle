extends Node2D

signal color_select(color)
signal cleared()


var ColorPickButton = preload("res://scenes/ColorPickButton.tscn")
var added = []
var revealed = false

onready var colors_container = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer
onready var name_label = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer2/NameLabel
onready var clear_button = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer2/Button

# Called when the node enters the scene tree for the first time.
func _ready():    
    $DraggableWindow.set_title("Palette")

func reveal():
    if not revealed:
        visible = true
        revealed = true
        $AnimationPlayer.play("FadeIn")
        
func reset():
    for c in colors_container.get_children():
        c.queue_free()
    reveal()
    
        
func set_palette(n, colors):
    if n == null:
        name_label.text = "*default*"
        clear_button.visible = false
    else:
        name_label.text = n
        clear_button.visible = true
    reset()
    for color in colors:
        var b = ColorPickButton.instance()
        b.modulate = color
        b.connect("pressed", self, "_on_ColorPickButton_pressed", [color])
        colors_container.add_child(b)
    reveal()
    emit_signal("color_select", colors[0])

func _on_ColorPickButton_pressed(color):
    emit_signal("color_select", color)


func _on_Button_pressed():
    emit_signal("cleared")
