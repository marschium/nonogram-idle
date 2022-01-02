extends Node2D

signal tile_clicked(tile)
signal tile_changed(tile)
signal complete()
signal complete_late()

var spacing = 34
var offset = 0

var PatternColorLabel = preload("res://scenes/ui/PatternColorLabel.tscn")

export var size = 1
var Tile = preload("res://scenes/Tile.tscn")
onready var dots = $Dots
var dots_lookup = Dictionary()

func reset():
	for c in dots.get_children():
		c.reset()
		
func check_cleared():
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
	offset = Vector2(viewportWidth/2 - gw/2, viewportHeight/2 - gh/2)
	
	for x in range(size):
		for y in range(size):
			var t = Tile.instance()
			var pos = Vector2(spacing * x, spacing * y) + offset
			t.x = x
			t.y = y
			t.position = pos
			t.connect("clicked", self, "_on_Tile_clicked", [t])
			t.connect("changed", self, "_on_Tile_changed", [t])
			dots.add_child(t)
			
			if not dots_lookup.has(x):
				dots_lookup[x] = Dictionary()
			dots_lookup[x][y] = t
			
func hide_guide():
	for c in $Guide.get_children():
		c.queue_free()
			
func show_guide(pattern_tiles):
	hide_guide()
	for x in range(self.size):
		var colors = {}
		for y in range(self.size):
			var t = pattern_tiles[x][y]
			if not colors.has(t):
				colors[t] = 1
			else:
				colors[t] += 1
				
		var yo = -38
		for c in colors.keys():
			var l = PatternColorLabel.instance()
			l.color = c
			l.count = colors[c]
			l.position = Vector2(spacing * x, yo) + offset
			$Guide.add_child(l)
			yo -= 38
	
	for y in range(self.size):
		var colors = {}
		for x in range(self.size):
			var t = pattern_tiles[x][y]
			if not colors.has(t):
				colors[t] = 1
			else:
				colors[t] += 1
				
		var xo = -38
		for c in colors.keys():
			var l = PatternColorLabel.instance()
			l.color = c
			l.count = colors[c]
			l.position = Vector2(xo, spacing * y) + offset
			$Guide.add_child(l)
			xo -= 38

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_board(size)

func _on_Tile_clicked(tile):
	emit_signal("tile_clicked", tile)
	
func _on_Tile_changed(tile):
	emit_signal("tile_changed", tile)
	check_cleared()
