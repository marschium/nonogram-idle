extends Node2D

signal tile_clicked(tile)
signal tile_right_clicked(tile)
signal tile_changed(tile) # only emitted if tie changed for first time
signal tile_reset(tile)
signal complete()
signal complete_late()

var spacing = 34
var offset = 0
var pop_anchor = Vector2(0, 0)

export var size = 1
var Tile = preload("res://scenes/Tile.tscn")
onready var dots = $Dots
var dots_lookup = Dictionary()

func reset():
    for c in dots.get_children():
        c.reset()
    $Guide.reset()
        
func check_cleared():
    # TODO what happens to the guide if the board is cleared? reset it?
    var complete = true
    for c in dots.get_children():
        complete = complete and c.changed
    if complete:
        emit_signal("complete")
        emit_signal("complete_late")
        
func get_dot(x, y):
    return dots_lookup.get(x).get(y)
        
func change_dot(x, y, color):
    dots_lookup.get(x).get(y).change(color)
        
func next_unchanged():
    for c in dots.get_children():
        if not c.changed:
            return c
    return null
    
func reset_board(size):
    for c in dots.get_children():
        c.queue_free()
    self.size = size
    var viewportWidth = get_viewport().size.x
    var viewportHeight = get_viewport().size.y
    var gh = spacing * size
    var gw = spacing * size
    offset = Vector2((viewportWidth/2) - (gw/2), (viewportHeight/2) - (gh/2))
    
    for x in range(size):
        for y in range(size):
            var t = Tile.instance()
            var pos = Vector2(spacing * x, spacing * y) + offset
            t.anchor = pop_anchor
            t.x = x
            t.y = y
            t.position = pos
            t.connect("clicked", self, "_on_Tile_clicked", [t])
            t.connect("right_clicked", self, "_on_Tile_right_clicked", [t])
            t.connect("changed", self, "_on_Tile_changed", [t])
            t.connect("reset", self, "_on_Tile_reset", [t])
            dots.add_child(t)
            
            if not dots_lookup.has(x):
                dots_lookup[x] = Dictionary()
            dots_lookup[x][y] = t		
    
    $Guide.offset = offset
    $Guide.spacing = spacing
            
func hide_guide():
    $Guide.hide_guide()
            
func show_guide(pattern):
    # TODO board might already has some tiles set
    $Guide.show_guide(pattern)

# Called when the node enters the scene tree for the first time.
func _ready():
    reset_board(size)

func _on_Tile_clicked(tile):
    emit_signal("tile_clicked", tile)
    
func _on_Tile_right_clicked(tile):
    emit_signal("tile_right_clicked", tile)
    
func _on_Tile_changed(was_changed_before, tile):
    $Guide.tile_changed(tile)
    emit_signal("tile_changed", tile)
    #if not was_changed_before:
    #    Score.add(1)
    check_cleared()

func _on_Tile_reset(tile):
    $Guide.tile_changed(tile)
    #if tile.changed:
    #    Score.sub(1)
    emit_signal("tile_reset", tile)
