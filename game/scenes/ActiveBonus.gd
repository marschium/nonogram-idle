extends Node2D

signal deactivated()

var bonus_name = ""
var text = ""
var time = 60

func _ready():
	$Timer.start(time)

func _on_Timer_timeout():
	emit_signal("deactivated")

func elapsed():
	return time - $Timer.time_left
