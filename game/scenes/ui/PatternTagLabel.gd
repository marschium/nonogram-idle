extends PanelContainer


export var color = Color(1, 0.87, 0.8)
var text = ""

func _ready():
	$Label.text = text
	modulate = color
	# TODO change the background color somehow?
