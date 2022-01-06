extends PanelContainer

signal cleared()

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
func reveal():
    visible = true
    $AnimationPlayer.play("FadeIn")


func set_guide(pattern):
    # TODO update the label when pattern is unlocked
    if not pattern.unlocked:
        $VBoxContainer/Label.text = "??????"
    else:
        $VBoxContainer/Label.text = pattern.pattern_name


func _on_Button_pressed():
    $VBoxContainer/Label.text = "NO ACTIVE GUIDE"
    emit_signal("cleared")
