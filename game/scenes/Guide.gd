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

	if t.current_color != pattern.tiles[t.x][t.y]:
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
	
func sortColors(a, b):
	return hash(a) < hash(b)
			
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
					current_colors[current_tile] = 1
				else:
					current_colors[current_tile] += 1
				
		columns.append([])
		var yo = -38
		var colors_keys = colors.keys()
		colors_keys.sort_custom(self, "sortColors")
		for c in colors_keys:
			var l = PatternColorLabel.instance()
			l.color = c
			l.max_count = colors[c]
			l.count = current_colors.get(c, 0)
			l.position = Vector2(spacing * x, yo) + offset
			add_child(l)
			columns[x].append(l)
			yo -= 38
			
		var error_marker = PatternColorErrorLabel.instance()
		error_marker.position = Vector2(spacing * x, yo) + offset
		error_marker.visible = false
		column_error_markers.append(error_marker)
		add_child(error_marker)
	
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
					current_colors[current_tile] = 1
				else:
					current_colors[current_tile] += 1
		
		rows.append([])
		var xo = -38
		var colors_keys = colors.keys()
		colors_keys.sort_custom(self, "sortColors")
		for c in colors_keys:
			var l = PatternColorLabel.instance()
			l.color = c
			l.max_count = colors[c]
			l.count = current_colors.get(c, 0)
			l.position = Vector2(xo, spacing * y) + offset
			add_child(l)
			rows[y].append(l)
			xo -= 38
		
		var error_marker = PatternColorErrorLabel.instance()
		error_marker.position = Vector2(xo, spacing * y) + offset
		error_marker.visible = false
		row_error_markers.append(error_marker)
		add_child(error_marker)
			
	visible = true
