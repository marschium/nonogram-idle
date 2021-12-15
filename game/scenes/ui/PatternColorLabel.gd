extends Node2D

var color = Color(1, 1, 1)
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.modulate = color
	$Label.text = str(count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
