extends Node2D

signal click_any(color)
signal click(x, y, color)

export var running = false

var PatternAutoClicker = preload("res://scenes/PatternAutoClicker.tscn")

var single = false
var current_clicker_idx = 0

func _ready():
	$PatternAutoClicker.stop()
	$SingleAutoClicker.stop()
	
func has_clicker():
	return $PatternClickers.get_child_count() > 0
	
func current_clicker():
	return $PatternClickers.get_child(current_clicker_idx)
	
func next_clicker():
	current_clicker_idx += 1
	if current_clicker_idx >= $PatternClickers.get_child_count():
		current_clicker_idx = 0
	
func can_run():
	return !running and has_clicker() and len(current_clicker().clicks) != 0
	
func start(x, y):
	if not can_run():
		return
	running = true
	if single:
		$SingleAutoClicker.start()
	else:
		current_clicker().start(x, y)
	
func stop():
	if not running:
		return
	running = false
	if current_clicker() == null:
		return
	if single:
		$SingleAutoClicker.stop()
	else:
		current_clicker().stop()

func clear():
	for c in $PatternClickers.get_children():
		c.queue_free()

#func set_single():
#	# TODO color as param
#	if not single:
#		$PatternAutoClicker.stop()
#	if running:
#		$SingleAutoClicker.start()
#	single = true
	
func add_pattern(pattern):
	var p = PatternAutoClicker.instance()
	p.file = pattern.file
	p.pattern = pattern
	p.setup()
	p.stop()
	p.connect("click", self, "_on_PatternAutoClicker_click")
	$PatternClickers.add_child(p)
	
func remove_pattern(pattern):
	for c in $PatternClickers.get_children():
		if c.pattern == pattern:
			$PatternClickers.remove_child(c)
			c.queue_free()
	current_clicker_idx = current_clicker_idx - 1
	if current_clicker_idx >= $PatternClickers.get_child_count() or current_clicker_idx < 0:
		current_clicker_idx = 0
	if $PatternClickers.get_child_count() == 0:
		current_clicker_idx = 0
		stop()

#func set_pattern(x, y, pattern):
#	if single:
#		$SingleAutoClicker.stop()
#
#	$PatternAutoClicker.file = pattern.file
#	$PatternAutoClicker.setup()
#
#	if running:
#		$PatternAutoClicker.start(x, y)
#	single = false

func _on_PatternAutoClicker_click(x, y, color):
	emit_signal("click", x, y, color)

func _on_SingleAutoClicker_click(color):
	emit_signal("click_any", color)
