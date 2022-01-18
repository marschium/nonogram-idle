extends Node2D

# Declare member variables here. Examples:
var spacing = 34
var offset = 0
var columns = []
var rows = []
var column_error_markers = []
var row_error_markers = []

var column_errors = {}
var row_errors = {}
var pattern = null

var PatternColorLabel = preload("res://scenes/ui/PatternColorLabel.tscn")
var PatternColorErrorLabel = preload("res://scenes/ui/PatternColorErrorLabel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
func reset():
    if not visible:
        return
    column_errors.clear()
    for c in get_children():
        c.reset()

func tile_changed(t):
    if not visible:
        return

    if t.current_color != pattern.tile(t.x, t.y):
        column_error_markers[t.x].visible = true
        row_error_markers[t.y].visible = true
        
        if not column_errors.has(t.x):
            column_errors[t.x] = {}
        column_errors[t.x][Vector2(t.x, t.y)] = true
        
        if not row_errors.has(t.y):
            row_errors[t.y] = {}
        row_errors[t.y][Vector2(t.x, t.y)] = true
        
    # if matched. check to see if any rows/columns can be marked as error free
    elif column_errors.has(t.x) and row_errors.has(t.y):
        column_errors[t.x].erase(Vector2(t.x, t.y))
        if column_errors[t.x].empty():
            column_error_markers[t.x].visible = false
        
        row_errors[t.y].erase(Vector2(t.x, t.y))
        if row_errors[t.y].empty():
            row_error_markers[t.y].visible = false

func hide_guide():
    for c in get_children():
        c.queue_free()
    columns = []
    rows = []
    visible = false
    column_errors.clear()
    column_error_markers = []
    row_error_markers = []
    
func sortColors(a, b):
    return hash(a) < hash(b)
            
func show_guide(pattern):
    hide_guide()
    self.pattern = pattern
    # TODO iterate the tiles instead of using indices
    # TODO labels are current reversed on the x-axis
    for x in range(pattern.width):
        var y_offset = -38
        var current_label = null
        # TODO state machine this mess
        for y in range(pattern.height):
            # TODO each of these by colors instead of according to the board?
            var t = pattern.tile(x, y)
            if t != null and current_label == null:
                current_label = PatternColorLabel.instance()
                current_label.color = t
                current_label.max_count = 1
            elif t != null and current_label.color == t:
                current_label.max_count += 1
            elif current_label != null:
                current_label.position = Vector2(spacing * x, y_offset) + offset
                y_offset -= 38
                add_child(current_label)
                current_label = null
                if t != null:
                    current_label = PatternColorLabel.instance()
                    current_label.color = t
                    current_label.max_count = 1
        
        if current_label != null:
            current_label.position = Vector2(spacing * x, y_offset) + offset
            y_offset -= 38
            add_child(current_label)
#
        var error_marker = PatternColorErrorLabel.instance()
        error_marker.position = Vector2(spacing * x, y_offset) + offset
        error_marker.visible = false
        column_error_markers.append(error_marker)
        add_child(error_marker)
        
    for y in range(pattern.height):
        var x_offset = -38
        var current_label = null
        for x in range(pattern.width):
            # TODO each of these by colors instead of according to the board?
            var t = pattern.tile(x, y)
            if t != null and current_label == null:
                current_label = PatternColorLabel.instance()
                current_label.color = t
                current_label.max_count = 1
            elif t != null and current_label.color == t:
                current_label.max_count += 1
            elif current_label != null:
                current_label.position = Vector2(x_offset, y * spacing) + offset
                x_offset -= 38
                add_child(current_label)
                current_label = null
                if t != null:
                    current_label = PatternColorLabel.instance()
                    current_label.color = t
                    current_label.max_count = 1
        
        if current_label != null:
            current_label.position = Vector2(x_offset, spacing * y) + offset
            x_offset -= 38
            add_child(current_label)
#
        var error_marker = PatternColorErrorLabel.instance()
        error_marker.position = Vector2(x_offset, spacing * y) + offset
        error_marker.visible = false
        row_error_markers.append(error_marker)
        add_child(error_marker)
            
    visible = true
