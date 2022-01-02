extends PanelContainer

signal selected()

var title = ""
var description = ""
var cost = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/TitleLabel.text = title
	$VBoxContainer/DescriptionLabel.text = description
	$VBoxContainer/Button.text = str(cost)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal("selected")
