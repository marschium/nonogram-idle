extends Node2D

signal matched(bonus)
signal unlocked()

var file = ""
var pattern_name = ""
var bonus = 0
var tiles = Dictionary()
var tiles_unmatched = Dictionary()
var unlocked = false
var colors = Dictionary()
var tags = []

func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary
	
func unlock():	
	if not unlocked:
		unlocked = true
		emit_signal("unlocked")

# Called when the node enters the scene tree for the first time.
func _ready():
	var pattern_def = read_json_file(file)
	pattern_name = pattern_def.get("name", "test")
	bonus = pattern_def["bonus"]
	for t in pattern_def["tiles"]:
		var x = int(t["x"])
		var y = int(t["y"])
		if not tiles.has(x):
			tiles[x] = {}
		var color = Color(float(t["c"][0]) / 255.0, float(t["c"][1]) / 255.0, float(t["c"][2]) / 255.0)
		tiles[x][y] = color
		colors[color] = true
	tiles_unmatched = tiles.duplicate(true)
	if pattern_def.has("tags"):
		tags = pattern_def["tags"]

func _on_Gameboard_tile_changed(tile):
	if tiles.get(tile.x).get(tile.y) == tile.sprite.modulate:
		tiles_unmatched.get(tile.x).erase(tile.y)
		if tiles_unmatched.get(tile.x).empty():
			tiles_unmatched.erase(tile.x)

func _on_Gameboard_complete():
	if tiles_unmatched.empty():
		print_debug("pattern matched %s" % file)
		emit_signal("matched", bonus)
		unlock()
	tiles_unmatched = tiles.duplicate(true)
