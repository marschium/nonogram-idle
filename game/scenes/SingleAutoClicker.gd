extends Node2D


signal click(color)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func start():
    $Timer.start()
    
func stop():
    $Timer.stop()

func _on_Timer_timeout():    
    emit_signal("click", Color(1, 1, 0))
