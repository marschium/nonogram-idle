extends Node2D


var combo = null


# Called when the node enters the scene tree for the first time.
func _ready():
    $DraggableWindow.set_title("Combo Unlocked")
    $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/NameLabel.text = combo.name
    $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/DescriptionLabel.text = combo.desc


func _on_DraggableWindow_tree_exiting():
    queue_free()
