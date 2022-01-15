extends Node2D

var bonus_name = ""
var text = ""
var time = 60

func _ready():
	$Timer.start(time)

func _on_Timer_timeout():
	print_debug("bepp")

func elapsed():
	return time - $Timer.time_left
