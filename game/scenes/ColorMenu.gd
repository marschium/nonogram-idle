extends Control

signal color_select(color)
signal cleared()


var ColorPickButton = preload("res://scenes/ColorPickButton.tscn")
var added = []
var revealed = false


# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func reveal():
    if not revealed:
        visible = true
        revealed = true
        $AnimationPlayer.play("FadeIn")
        
func reset():
    for c in $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer.get_children():
        c.queue_free()
    reveal()
    
        
func set_palette(n, colors):
    if n == null:
        $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer2/NameLabel.text = "*default*"
        $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer2/Button.visible = false
    else:
        $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer2/NameLabel.text = n
        $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer2/Button.visible = true
    reset()
    for color in colors:
        var b = ColorPickButton.instance()
        b.modulate = color
        b.connect("pressed", self, "_on_ColorPickButton_pressed", [color])
        $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer.add_child(b)
    reveal()
    emit_signal("color_select", colors[0])

func _on_ColorPickButton_pressed(color):
    emit_signal("color_select", color)


func _on_Button_pressed():
    emit_signal("cleared")
