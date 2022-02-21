extends Node2D

var pattern = null
var PatternTagLabel = preload("res://scenes/ui/PatternTagLabel.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
    $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/TextureRect.texture = load("res://images/%s.png" % [pattern.pattern_name])
    $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/NameLabel.text = pattern.pattern_name
    for tag in pattern.tags:
        var p = PatternTagLabel.instance()
        p.text = tag
        $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/TagsHBoxContainer.add_child(p)


func _on_DraggableWindow_tree_exiting():
    queue_free()
