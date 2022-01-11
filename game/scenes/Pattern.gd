extends Node2D

signal matched(bonus)
signal unlocked()

var file = ""
var pattern_name = ""
var bonus = 0
var tiles = Dictionary()
var tiles_to_match = Dictionary()
var tiles_unmatched = Dictionary()
var unlocked = false
var colors = Dictionary()
var tags = []
var width = 0
var height = 0

func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary
	
func unlock(no_signal=false):	
	if not unlocked:
		unlocked = true
		emit_signal("unlocked")
		
func has(x, y):
	var v = Vector2(x, y)
	return tiles.has(v) and tiles[v] != null
	
func tile(x, y):
	var v = Vector2(x, y)
	return tiles[v]

# Called when the node enters the scene tree for the first time.
func _ready():
	var pattern_def = read_json_file(file)
	pattern_name = pattern_def.get("name", "test")
	bonus = pattern_def["bonus"]
	width = int(pattern_def["w"])
	height = int(pattern_def["h"])
	for x in range(width):
		for y in range(height):
			tiles[Vector2(x, y)] = null
	for t in pattern_def["tiles"]:
		var x = int(t["x"])
		var y = int(t["y"])
		var color = Color(float(t["c"][0]) / 255.0, float(t["c"][1]) / 255.0, float(t["c"][2]) / 255.0)
		tiles[Vector2(x, y)] = color
		tiles_to_match[Vector2(x, y)] = true
		colors[color] = true
	if pattern_def.has("tags"):
		tags = pattern_def["tags"]
	tiles_unmatched = tiles_to_match.duplicate(true)

func _on_Gameboard_tile_changed(tile):
	var v = Vector2(tile.x, tile.y)
	if tiles[v] == tile.current_color:
		tiles_unmatched.erase(v)
		if tiles_unmatched.empty():
			print_debug("pattern matched %s" % file)
			emit_signal("matched", bonus)
			unlock()
	else:
		tiles_unmatched[v] = true
		
func _on_Gameboard_tile_reset(tile):
	if has(tile.x, tile.y):
		tiles_unmatched[Vector2(tile.x, tile.y)] = true
	else:
		tiles_unmatched.erase(Vector2(tile.x, tile.y))

func reset():
	tiles_unmatched = tiles_to_match.duplicate(true)
