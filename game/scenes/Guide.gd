extends Node2D

# Show total number of color for each row/column
# Do NOT countdown
# Flag when wrong color
# Hide count when number of color is draw in row/column. Even if incorrect
# Show error if more than color is drawn in row/colum

# Declare member variables here. Examples:
var spacing = 34
var offset = 0
var columns = []
var rows = []

var pattern = null

var GuideRow = preload("res://scenes/ui/GuideRow.tscn")
var PatternColorLabel = preload("res://scenes/ui/PatternColorLabel.tscn")
var PatternColorErrorLabel = preload("res://scenes/ui/PatternColorErrorLabel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
func reset():
    #columns = []
    #rows = []
    if not visible:
        return
    for c in get_children():
        c.reset()

func tile_changed(t):
    if not visible:
        return

    columns[t.x].tile_changed(t)
    rows[t.y].tile_changed(t)

func hide_guide():
    for c in get_children():
        c.queue_free()
    columns = []
    rows = []
    visible = false
    
func sortColors(a, b):
    return hash(a) < hash(b)
    
class TrackColors:
    var seen = []
    var seperated = []
    var current = null
    
    func next(color):
        if color != null and seen.has(color):
            seperated.append(color)# revisting a color
        elif current != null and color != current:
            seen.append(current)
        current = color
        
            
func show_guide(pattern):
    hide_guide()
    self.pattern = pattern
    
    var all_colors = {}
    var prev_color = null
    for x in range(pattern.width):
        var y_offset = -42
        var guide_row = GuideRow.instance()
        var track_colors = TrackColors.new()
        for y in range(pattern.height):
            var t = pattern.tile(x, y)
            if t != null:
                guide_row.increment_color(t)   
                if not all_colors.has(t):
                    all_colors[t] = all_colors.size()             
            track_colors.next(t)
            
        for t in track_colors.seperated:
            guide_row.mark_seperated_color(t)           
            
        guide_row.horizontal = false
        guide_row.position = Vector2(x * spacing, y_offset) + offset
        add_child(guide_row)
        columns.append(guide_row)
    
    for y in range(pattern.height):
        var x_offset = -42
        var guide_row = GuideRow.instance()
        var track_colors = TrackColors.new()
        for x in range(pattern.width):
            var t = pattern.tile(x, y)
            if t != null:
                guide_row.increment_color(t)
                if not all_colors.has(t):
                    all_colors[t] = all_colors.size()             
            track_colors.next(t)    
            
        for t in track_colors.seperated:
            guide_row.mark_seperated_color(t)       
             
        guide_row.horizontal = true
        guide_row.position = Vector2(x_offset, y * spacing) + offset
        add_child(guide_row)
        rows.append(guide_row)         
    
    # insure consistent placement of colors across rows/columns
    for c in all_colors.keys():
        for gr in columns:
            gr.set_color_index(c, all_colors[c])    
        for gr in rows:
            gr.set_color_index(c, all_colors[c])
            
    for c in columns:
        c.show()
    for r in rows:
        r.show()
            
    visible = true
