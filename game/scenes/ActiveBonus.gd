extends Node2D

signal activated()
signal deactivated()
signal unlocked()

var active = false
var bonus_name = ""
var text = ""
var time = 60
var id = ""
var effect = null
var unlocked = false

func _ready():
    pass
    
func activate():
    active = true
    $Timer.start(time)
    emit_signal("activated")
    if not unlocked:
        unlocked = true
        emit_signal("unlocked")

func _on_Timer_timeout():
    deactivate()
    
func remaining():
    return $Timer.time_left

func elapsed():
    return time - $Timer.time_left

func deactivate():
    active = false
    $Timer.stop()
    emit_signal("deactivated")
