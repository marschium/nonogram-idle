extends Node2D

var color = Color(1, 1, 1)
var max_count = 0
var count = 0

onready var label = $Panel/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.modulate = color
	label.text = str(max_count - count)
	
func reset():
	count = 0 
	label.text = str(max_count - count)

func matched():
	count += 1	
	label.text = str(max_count - count)

func unmatched():
	count -= 1	
	label.text = str(max_count - count)
