extends Node2D

var color = Color(1, 1, 1)
var max_count = 0
var count = 0

onready var label = $Panel/Label

func change_label():	
    label.text = str(max_count)
    

# Called when the node enters the scene tree for the first time.
func _ready():
    $Panel.modulate = color
    change_label()
    
func reset():
    count = 0 
    change_label()

func show_no_error():
    change_label()

func show_error():
    # TODO flash with color?
    $Panel/Label.text = "X"
