extends PanelContainer

signal pattern_removed(pattern)
signal play()
signal stop()

var ActivePatternControl = preload("res://scenes/ui/ActivePatternControl.tscn")

onready var active_pattern_container = $VBoxContainer/ActivePatternVBoxContainer

export var AutoclickerNode : NodePath = ""
var autoclicker = null

# Called when the node enters the scene tree for the first time.
func _ready():
    autoclicker = get_node(AutoclickerNode)
    autoclicker.connect("pattern_added", self, "_on_Autoclicker_pattern_added")
    autoclicker.connect("pattern_changed", self, "_on_Autoclicker_pattern_changed")
    autoclicker.connect("pattern_removed", self, "_on_Autoclicker_pattern_removed")
    autoclicker.connect("started", self, "_on_Autoclicker_started")
    autoclicker.connect("stopped", self, "_on_Autoclicker_stopped")

    
func autoclicker_stopped():
    $VBoxContainer/HBoxContainer/PauseButton.pressed = true

func _on_Autoclicker_pattern_added(pattern):
    for c in active_pattern_container.get_children():
        if c.pattern == pattern:
            return

    var b = ActivePatternControl.instance()
    b.pattern = pattern
    b.connect("removed", self, "_on_ActivePatternControl_removed", [pattern])
    active_pattern_container.add_child(b)
    
func _on_Autoclicker_pattern_removed(pattern):
    for c in active_pattern_container.get_children():
        if c.pattern == pattern:
            c.queue_free()

func _on_Autoclicker_pattern_changed(pattern):
    for c in active_pattern_container.get_children():
        if c.pattern == pattern:
            c.mark_active()
        else:
            c.mark_inactive()
            
func reveal():
    visible = true
    $AnimationPlayer.play("FadeIn")

func _on_Autoclicker_started():
    $VBoxContainer/HBoxContainer/PlayButton.pressed = true
    
func _on_Autoclicker_stopped():
    $VBoxContainer/HBoxContainer/PauseButton.pressed = true

func _on_ActivePatternControl_removed(pattern):
    emit_signal("pattern_removed", pattern)

func _on_PauseButton_pressed():
    emit_signal("stop")

func _on_PlayButton_pressed():
    emit_signal("play")
