extends Node2D

var color = Color(1, 1, 1)
var max_count = 0
var count = 0
var showing = false
var solid = true

onready var label = $Label

func change_label():	
    label.text = str(max_count)
    

# Called when the node enters the scene tree for the first time.
func _ready():
    $SolidTextureRect.modulate = color
    $GapTextureRect.modulate = color
    $SolidTextureRect.visible = solid
    $GapTextureRect.visible = ! solid
    change_label()
    self.modulate = Color(1.0, 1.0, 1.0, 0.0)
    
func reset():
    count = 0 
    change_label()
    
func show():
    $Tween.stop_all()
    $Tween.interpolate_property(
        self, 
        "modulate", 
        self.modulate, 
        Color(1.0, 1.0, 1.0, 1.0), 
        1, 
        Tween.TRANS_LINEAR, 
        Tween.EASE_IN_OUT)
    $Tween.start()
    
func hide():
    $Tween.stop_all()
    $Tween.interpolate_property(
        self, 
        "modulate", 
        self.modulate, 
        Color(1.0, 1.0, 1.0, 0.0), 
        1, 
        Tween.TRANS_LINEAR, 
        Tween.EASE_IN_OUT)
    $Tween.start()

func show_no_error():
    pass

func show_error():
    pass
