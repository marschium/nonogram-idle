extends Control

signal guide_selected(pattern)
signal set_selected(pattern)

var PatternTagLabel = preload("res://scenes/ui/PatternTagLabel.tscn")

onready var set_button = $HBoxContainer/MarginContainer/HBoxContainer/SetButton
onready var name_label = $HBoxContainer/VBoxContainer/NameLabel

var pattern = null
var autoclick_enabled = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func enable_autoclick():
    autoclick_enabled = true
    if pattern.unlocked:
        set_button.disabled = false
        
func show_tags():	
    for tag in pattern.tags:
        var l = PatternTagLabel.instance()
        l.text = tag
        $HBoxContainer/VBoxContainer/CenterContainer.add_child(l)
        
func unlock():
    set_button.visible = pattern.unlocked
    set_button.disabled = !autoclick_enabled
    name_label.text = pattern.pattern_name
    name_label.modulate = Color(0, 1, 0)
    show_tags()

# Called when the node enters the scene tree for the first time.
func _ready():
    # TODO only show set if unlocked
    if pattern == null:
        return
    set_button.disabled = true
    pattern.connect("unlocked", self, "_on_Pattern_unlocked")
    pattern.connect("activated", self, "_on_Pattern_activated")
    # set_button.visible = pattern.unlocked
    if pattern.unlocked:
        unlock()

func force_toggle_set_button(pressed):
    set_button.pressed = pressed


func _on_Pattern_unlocked():
    unlock()
    
func _on_Pattern_activated():
    visible = true

func _on_SetButton_pressed():	
    emit_signal("set_selected", pattern)


func _on_GuideButton_pressed():
    emit_signal("guide_selected", pattern)
