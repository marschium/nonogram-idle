extends Control

signal pattern_selected(pattern)
signal guide_selected(pattern)

var PatternSelectControl = preload("res://scenes/ui/PatternSelectControl.tscn")

onready var pattern_select_vbox = $VBoxContainer/ScrollContainer/PatternSelectVBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func add_pattern(pattern):
    var l = PatternSelectControl.instance()
    l.pattern = pattern
    l.connect("guide_selected", self, "_on_PatternSelect_guide_selected")
    l.connect("set_selected", self, "_on_PatternSelect_set_selected")
    l.visible = pattern.active
    pattern_select_vbox.add_child(l)
    
func enable_autoclick():
    for pc in pattern_select_vbox.get_children():
        pc.enable_autoclick()

        
func reveal():
    $AnimationPlayer.play("FadeIn")
    visible = true

func _on_PatternSelect_guide_selected(pattern):
    emit_signal("guide_selected", pattern)

func _on_PatternSelect_set_selected(pattern):
    emit_signal("pattern_selected", pattern)
