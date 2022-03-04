extends Node2D

signal click_any(color)
signal click(x, y, color)
signal pattern_clicker_added(clicker)
signal pattern_clicker_changed(clicker)
signal pattern_clicker_removed(clicker)
signal cycle_finished()
signal started()
signal stopped()
signal shuffle_disabled()

export var running = false

var PatternAutoClicker = preload("res://scenes/PatternAutoClicker.tscn")

var single = false
var current_clicker_idx = 0
var speed = 1
var pause_clicker_pos = Vector2(0, 0)
var max_clickers = 3
var loop = false
var shuffle = false

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
        emit_signal("cycle_finished")
        if not loop:
            stop()
        # clear() make configurable
    if $PatternClickers.get_child_count() > 0:
        emit_signal("pattern_clicker_changed", current_clicker())
        current_clicker().set_speed(speed)
    
func can_run():
    return !running and has_clicker() and len(current_clicker().clicks) != 0
    
func start(x, y):
    if not can_run():
        return
    running = true
    current_clicker().start(x, y)
    emit_signal("started")
    emit_signal("pattern_clicker_changed", current_clicker())
    
func resume():
    if current_clicker() == null:
        return
    current_clicker().resume()
    emit_signal("started")
    
func pause():
    if current_clicker() == null:
        return
    current_clicker().pause()
    emit_signal("stopped")
    
func stop():
    if not running:
        emit_signal("stopped")
        return
    running = false
    if current_clicker() == null:
        return
    current_clicker().stop()
    emit_signal("stopped")
    
func set_pos(x, y):
    if current_clicker() != null:
        current_clicker().set_pos(x, y)
    
func get_current():
    return current_clicker().get_current().c
    
func set_speed(speed):
    self.speed = speed
    if current_clicker() != null:
        current_clicker().set_speed(speed)

func clear(stop=true):
    for c in $PatternClickers.get_children():
        $PatternClickers.remove_child(c)
        emit_signal("pattern_clicker_removed", c)
        c.queue_free()
    current_clicker_idx = 0
    if stop:
        stop()
    
func clicker_count():
    return $PatternClickers.get_child_count()
    
func add_pattern(pattern):
    if $PatternClickers.get_child_count() >= max_clickers:
        return
    var p = PatternAutoClicker.instance()
    p.file = pattern.file
    p.pattern = pattern
    p.setup()
    p.stop()
    p.connect("click", self, "_on_PatternAutoClicker_click")
    p.set_speed(speed)
    $PatternClickers.add_child(p)
    emit_signal("pattern_clicker_added", p)
    
func remove_pattern_clicker(clicker):
    # TODO emit signals and link to the ui?
    for c in $PatternClickers.get_children():
        if c == clicker:
            $PatternClickers.remove_child(c)
            c.queue_free()			
            emit_signal("pattern_clicker_removed", c)
    current_clicker_idx = current_clicker_idx - 1
    if current_clicker_idx >= $PatternClickers.get_child_count() or current_clicker_idx < 0:
        current_clicker_idx = 0
    if $PatternClickers.get_child_count() == 0:
        current_clicker_idx = 0
        stop()
        shuffle = false
        emit_signal("shuffle_disabled")

func _on_PatternAutoClicker_click(x, y, color):
    emit_signal("click", x, y, color)

func _on_SingleAutoClicker_click(color):
    emit_signal("click_any", color)
