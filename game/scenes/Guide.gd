extends Node2D

# Declare member variables here. Examples:
var spacing = 34
var offset = 0
var columns = []
var rows = []
var pattern = null

var PatternColorLabel = preload("res://scenes/ui/PatternColorLabel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func reset():
	if not visible:
		return
	for c in get_children():
		c.reset()

func tile_changed(t):
	if not visible:
		return
	# if the tile as just been matched
	if t.current_color == pattern.tiles[t.x][t.y]:
		for pl in columns[t.x]:
			if pl.color == t.current_color:
				pl.matched()
			
		for pl in rows[t.y]:
			if pl.color == t.current_color:
				pl.matched()
				
	# if the tile was previously matched
	if t.previous_color == pattern.tiles[t.x][t.y]:
		for pl in columns[t.x]:
			if pl.color == t.previous_color:
				pl.unmatched()
			
		for pl in rows[t.y]:
			if pl.color == t.previous_color:
				pl.unmatched()

func hide_guide():
	for c in get_children():
		c.queue_free()
	columns = []
	rows = []
	visible = false
			
func show_guide(tiles, pattern):
	hide_guide()
	self.pattern = pattern
	var pattern_tiles = pattern.tiles
	for x in range(pattern.width):
		var colors = {}
		var current_colors = {}
		for y in range(pattern.height):
			var t = pattern_tiles[x][y]
			var current_tile = tiles[x][y].current_color
			if not colors.has(t):
				colors[t] = 1
			else:
				colors[t] += 1
			
			if current_tile != null:
				if not current_colors.has(current_tile):
					current_colors[t] = 1
				else:
					current_colors[t] += 1
				
		columns.append([])
		var yo = -38
		for c in colors.keys():
			var l = PatternColorLabel.instance()
			l.color = c
			l.max_count = colors[c]
			l.count = current_colors.get(c, 0)
			l.position = Vector2(spacing * x, yo) + offset
			add_child(l)
			columns[x].append(l)
			yo -= 38
	
	for y in range(pattern.height):
		var colors = {}
		var current_colors = {}
		for x in range(pattern.width):
			var t = pattern_tiles[x][y]
			var current_tile = tiles[x][y].current_color
			if not colors.has(t):
				colors[t] = 1
			else:
				colors[t] += 1
				
			if current_tile != null:
				if not current_colors.has(current_tile):
					current_colors[t] = 1
				else:
					current_colors[t] += 1
		
		rows.append([])
		var xo = -38
		for c in colors.keys():
			var l = PatternColorLabel.instance()
			l.color = c
			l.max_count = colors[c]
			l.count = current_colors.get(c, 0)
			l.position = Vector2(xo, spacing * y) + offset
			add_child(l)
			rows[y].append(l)
			xo -= 38
	visible = true
