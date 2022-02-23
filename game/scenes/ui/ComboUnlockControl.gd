extends Node2D


var combo = null


# Called when the node enters the scene tree for the first time.
func _ready():
    $DraggableWindow.set_title("Combo Unlocked")
    $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/NameLabel.text = combo.name
    $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/DescriptionLabel.text = combo.desc
    
    for n in combo.names:
        var t = TextureRect.new()
        t.texture = load("res://images/%s.png" % [n])
        t.rect_min_size = Vector2(64, 64)
        t.stretch_mode = TextureRect.STRETCH_SCALE
        $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/PatternsHBoxContainer.add_child(t)
        
    $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/MarginContainer/VBoxContainer/ComboTextureRect.texture = load("res://images/bonuses/%s.png" % [combo.name.to_lower()])


func _on_DraggableWindow_tree_exiting():
    queue_free()
