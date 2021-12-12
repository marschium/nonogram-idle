extends Node2D

signal click_any(color)
signal click(x, y, color)

export var running = false

var single = true

func _ready():
	$PatternAutoClicker.stop()
	$SingleAutoClicker.stop()
	
func start(x, y):
	if running:
		return
	running = true
	if single:
		$SingleAutoClicker.start()
	else:
		$PatternAutoClicker.start(x, y)
	
func stop():
	if not running:
		return
	running = false
	if single:
		$SingleAutoClicker.stop()
	else:
		$PatternAutoClicker.stop()

func set_single():
	# TODO color as param
	if not single:
		$PatternAutoClicker.stop()
	if running:
		$SingleAutoClicker.start()
	single = true
	
func set_pattern(x, y):
	# TODO pattern as param
	if single:
		$SingleAutoClicker.stop()
	if running:
		$PatternAutoClicker.start(x, y)
	single = false

func _on_PatternAutoClicker_click(x, y, color):
	emit_signal("click", x, y, color)

func _on_SingleAutoClicker_click(color):
	emit_signal("click_any", color)
