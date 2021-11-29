extends Node2D

signal tile_changed()
signal cleared()

var Tile = preload("res://scenes/Tile.tscn")

func reset():
    # TODO animate
    for c in get_children():
        c.reset()
        
func check_cleared():
    var complete = true
    for c in get_children():
        complete = complete and c.changed
    if complete:
        reset()
        emit_signal("cleared")

# Called when the node enters the scene tree for the first time.
func _ready():
    var viewportWidth = get_viewport().size.x
    var viewportHeight = get_viewport().size.y
    var spacing = 64
    var offset = Vector2(viewportWidth/2, viewportHeight/2)
    
    for x in range(4):
        for y in range(4):
            var t = Tile.instance()
            var pos = Vector2(spacing * x, spacing * y) + offset
            t.position = pos
            t.connect("clicked", self, "_on_Tile_clicked", [t])
            add_child(t)

func _on_Tile_clicked(tile):
    tile.change(Color(0, 1, 0))
    emit_signal("tile_changed")
    check_cleared()
