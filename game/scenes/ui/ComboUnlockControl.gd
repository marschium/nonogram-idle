extends Node2D


var combo = null


# Called when the node enters the scene tree for the first time.
func _ready():
    $DraggableWindow.set_title("Bonus Unlocked")
    $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/NameLabel.text = combo.name
    $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/DescriptionLabel.text = Bonus.bonus_by_name(combo.bonus_id).text
    
    # TODO how to represent the unlock condition of the bonus? might not just be a combo? just put into a seperate unlock window is probably easieset
    for n in combo.names:
        var t = TextureRect.new()
        t.texture = load("res://images/%s.png" % [n])
        t.rect_min_size = Vector2(64, 64)
        t.stretch_mode = TextureRect.STRETCH_SCALE
        $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/PatternsHBoxContainer.add_child(t)
        
    $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ComboTextureRect.texture = load("res://images/bonuses/%s.png" % [Bonus.bonus_by_name(combo.bonus_id).id.to_lower()])


func _on_DraggableWindow_tree_exiting():
    queue_free()
