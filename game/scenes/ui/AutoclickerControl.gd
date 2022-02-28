extends Node2D

signal pattern_clicker_removed(clicker)
signal play()
signal stop()
signal loop_toggled(enabled)

var ActivePatternControl = preload("res://scenes/ui/ActivePatternControl.tscn")

onready var active_pattern_container = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/ActivePatternVBoxContainer
onready var pause_button = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/PauseButton
onready var count_label = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/CountLabel
onready var play_button = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/PlayButton
onready var loop_button = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer/HBoxContainer/LoopButton

export var AutoclickerNode : NodePath = ""
var autoclicker = null

# Called when the node enters the scene tree for the first time.
func _ready():
    autoclicker = get_node(AutoclickerNode)
    autoclicker.connect("pattern_clicker_added", self, "_on_Autoclicker_pattern_clicker_added")
    autoclicker.connect("pattern_clicker_changed", self, "_on_Autoclicker_pattern_clicker_changed")
    autoclicker.connect("pattern_clicker_removed", self, "_on_Autoclicker_pattern_clicker_removed")
    autoclicker.connect("started", self, "_on_Autoclicker_started")
    autoclicker.connect("stopped", self, "_on_Autoclicker_stopped")
    $DraggableWindow.set_title("Autoclicking")
    update_counter()

    
func autoclicker_stopped():
    pause_button.pressed = true
    
func update_counter():
    count_label.text = "%s/%s" % [autoclicker.clicker_count(), autoclicker.max_clickers]
    

func _on_Autoclicker_pattern_clicker_added(clicker):
    var b = ActivePatternControl.instance()
    b.clicker = clicker
    b.connect("removed", self, "_on_ActivePatternControl_removed", [clicker])
    active_pattern_container.add_child(b)
    update_counter()
    
func _on_Autoclicker_pattern_clicker_removed(clicker):
    for c in active_pattern_container.get_children():
        if c.clicker == clicker:
            c.queue_free()
    update_counter()
    
func _on_Autoclicker_pattern_clicker_changed(clicker):
    for c in active_pattern_container.get_children():
        if c.clicker == clicker:
            c.mark_active()
        else:
            c.mark_inactive()
            
func reveal():
    visible = true
    $AnimationPlayer.play("FadeIn")

func _on_Autoclicker_started():
    play_button.pressed = true
    
func _on_Autoclicker_stopped():
    pause_button.pressed = true

func _on_ActivePatternControl_removed(pattern):
    emit_signal("pattern_clicker_removed", pattern)

func _on_PauseButton_pressed():
    emit_signal("stop")

func _on_PlayButton_pressed():
    emit_signal("play")

func _on_LoopButton_toggled(button_pressed):
    emit_signal("loop_toggled", button_pressed)
