extends Node2D

signal available()
signal active()


var available_at = 0
var cost = 0
var val = null
var desc = ""
var tag = ""

var available = false
var active = false
    
func setup(a, c, v, d, t):
    available_at = a
    cost = c
    val = v
    desc = d
    tag = t

func _ready():    
    Score.connect("changed", self, "_on_Score_changed")
    
func _on_Score_changed(old, new):
    if Score.val >= available_at and not available:
        available = true
        emit_signal("available")
        
func buy():
    if Score.val >= cost and available and not active:
        Score.sub(cost)
        active = true
        emit_signal("active")
