extends Node2D

var color = Color(1, 1, 1)
var max_count = 0
var count = 0

onready var label = $Panel/Label

func change_label():	
	var x = max_count - count
	label.text = str(x)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.modulate = color
	change_label()
	
func reset():
	count = 0 
	change_label()

func matched():
	count += 1	
	change_label()

func unmatched():
	count -= 1	
	change_label()
