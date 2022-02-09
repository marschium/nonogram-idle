extends Node2D

signal available()
signal active()


var available_at = 0
var cost = 0
var val = null
var desc = ""
var tag = ""
var conditions = []

var available = false
var active = false
    
func setup(a, c, v, d, t):
    available_at = a
    cost = c
    val = v
    desc = d
    tag = t
    
func _check_available():
    if Score.val >= available_at and not available and conditions.empty():
        available = true
        emit_signal("available")
    
func set_condition(cond):
    conditions.append(cond)
    
func remove_condition(cond):
    conditions.erase(cond)
    _check_available()
    
    
func savegame(savedata):
    if active:
        savedata["upgrades"][tag].append(val)

func loadgame(savedata):
    if savedata["upgrades"].has(tag):
        if savedata["upgrades"][tag].has(int(val)): # TODO probably int comparison error here
            active = true
            emit_signal("active")            

func _ready():    
    Score.connect("changed", self, "_on_Score_changed")
    
func _on_Score_changed(old, new):
    _check_available()
        
func buy():
    if Score.val >= cost and available and not active:
        Score.sub(cost)
        active = true
        emit_signal("active")
