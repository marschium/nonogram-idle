extends Control

signal autoclick_toggled(enabled)
signal pattern_selected(pattern)
signal pattern_clicker_toggled(enabled, clicker)
signal guide_toggled(enabled, pattern)
signal autoclick_loop(enabled)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func set_autoclicker(clicker):
    $VBoxContainer/AutoclickerControl.autoclicker = clicker

func enable_autoclick():
    $VBoxContainer/AutoclickerControl.reveal()
    $VBoxContainer/PatternsControl.enable_autoclick()
    
func enable_pattern_select():
    $VBoxContainer/PatternsControl.reveal()
    
func add_pattern(pattern):
    $VBoxContainer/PatternsControl.add_pattern(pattern)

func _on_PatternsControl_pattern_selected(pattern):
    if not pattern.unlocked:
        return	
    emit_signal("pattern_selected", pattern)


func _on_PatternsControl_guide_selected(pattern):
    emit_signal("guide_toggled", true, pattern)
    

func _on_AutoclickerControl_play():
    emit_signal("autoclick_toggled", true)
    

func _on_AutoclickerControl_stop():
    emit_signal("autoclick_toggled", false)


func _on_GuideControl_cleared():	
    emit_signal("guide_toggled", false, null)


func _on_AutoclickerControl_pattern_clicker_removed(clicker):
    emit_signal("pattern_clicker_toggled", false, clicker)


func _on_AutoclickerControl_loop_toggled(enabled):
    emit_signal("autoclick_loop", enabled)
