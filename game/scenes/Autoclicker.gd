extends Node2D

signal click(color)

export var running = false
export var color = Color(0, 0, 1)

func start():
	$Timer.start()

func stop():
	$Timer.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	if running:
		$Timer.start()
	else:
		$Timer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Timer_timeout():
	emit_signal("click", color)
