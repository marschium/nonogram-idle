extends PanelContainer

signal selected()

var title = ""
var description = ""
var cost = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    $MarginContainer/VBoxContainer/TitleLabel.text = title
    $MarginContainer/VBoxContainer/DescriptionLabel.text = description
    $MarginContainer/VBoxContainer/HBoxContainer/CostLabel.text = "(%s)" % [str(cost)]
    $MarginContainer/VBoxContainer/HBoxContainer/Button.disabled = Score.val < cost
    Score.connect("changed", self, "_on_Score_changed")


func _on_Score_changed(old, new):    
    $MarginContainer/VBoxContainer/HBoxContainer/Button.disabled = new < cost


func _on_Button_pressed():
    emit_signal("selected")
