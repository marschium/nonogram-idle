extends Node2D

var color = Color(1, 1, 1)
var max_count = 0
var count = 0
var solid = true

onready var label = $Label

func change_label():	
    label.text = str(max_count)
    

# Called when the node enters the scene tree for the first time.
func _ready():
    # solid = max_count == 1
    $Panel.modulate = color
    $SolidTextureRect.modulate = color
    $GapTextureRect.modulate = color
    $SolidTextureRect.visible = solid
    $GapTextureRect.visible = ! solid
    change_label()
    
func reset():
    count = 0 
    change_label()

func show_no_error():
    pass

func show_error():
    pass
