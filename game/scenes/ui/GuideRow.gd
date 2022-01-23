extends Node2D

var PatternColorLabel = preload("res://scenes/ui/PatternColorLabel.tscn")
var PatternColorErrorLabel = preload("res://scenes/ui/PatternColorErrorLabel.tscn")

var expected_counts = {}
var errors = []
var current_tiles = {}

var horizontal = true
var error_label = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func increment_color(color):
    if not expected_counts.has(color):
        expected_counts[color] = 0
    expected_counts[color] += 1

func show():
    var offset = Vector2(0, 0)
    for c in expected_counts.keys():
        var l = PatternColorLabel.instance()
        l.color = c
        l.max_count = expected_counts[c]
        if horizontal:
            offset.x -= 34
        else:            
            offset.y -= 34
        l.position = offset
        $Control.add_child(l)
            
    error_label = PatternColorErrorLabel.instance()
    error_label.visible = false
    if horizontal:
        offset.x -= 34
    else:
        offset.y -= 34    
    error_label.position = offset
    $Control.add_child(error_label)
        
func tile_changed(t):
    var id = Vector2(t.x, t.y)
    if t.current_color != null:
        current_tiles[id] = t.current_color
    else:
        current_tiles.erase(id)
    
    var counts = {}
    var incorrect_color = false
    var too_many = false
    for tid in current_tiles.keys():
        var c = current_tiles[tid]
        if not expected_counts.has(c):
            incorrect_color = true
            
        if not counts.has(c):
            counts[c] = 0
        counts[c] += 1
        
    if not incorrect_color:
        for c in counts.keys():
            if expected_counts.has(c) and counts[c] > expected_counts[c]:
                too_many = true

    error_label.visible = too_many or incorrect_color
        
    

func reset():
    expected_counts = {}
