extends Node2D

signal tile_clicked(tile)
signal tile_changed(tile)
signal complete()

var Tile = preload("res://scenes/Tile.tscn")
onready var dots = $Dots

func reset():
	for c in dots.get_children():
		c.reset()
		
func check_cleared():
	var complete = true
	for c in dots.get_children():
		complete = complete and c.changed
	if complete:
		emit_signal("complete")
		
func next_unchanged():
	for c in dots.get_children():
		if not c.changed:
			return c
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y
	var spacing = 64
	var gh = 64 * 4
	var gw = 64 * 4
	var offset = Vector2(viewportWidth/2 - gw/2, viewportHeight/2 - gh/2)
	
	for x in range(4):
		for y in range(4):
			var t = Tile.instance()
			var pos = Vector2(spacing * x, spacing * y) + offset
			t.x = x
			t.y = y
			t.position = pos
			t.connect("clicked", self, "_on_Tile_clicked", [t])
			t.connect("changed", self, "_on_Tile_changed", [t])
			dots.add_child(t)

func _on_Tile_clicked(tile):
	emit_signal("tile_clicked", tile)
	
func _on_Tile_changed(tile):
	emit_signal("tile_changed", tile)
	check_cleared()
