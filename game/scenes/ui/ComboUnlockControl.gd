extends PanelContainer


var combo = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/VBoxContainer/NameLabel.text = combo.name
	$CenterContainer/VBoxContainer/DescriptionLabel.text = combo.desc


func _on_Button_pressed():
	queue_free()
