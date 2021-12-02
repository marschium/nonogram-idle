extends Node2D


var file = "res://example.json"
var tiles = Dictionary()

func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	var pattern_def = read_json_file(file)
	for t in pattern_def["tiles"]:
		var x = int(t["x"])
		var y = int(t["y"])
		if not tiles.has(t["x"]):
			tiles[x] = Dictionary()
		tiles[x][y] = Color(float(t["c"][0]) / 255.0, float(t["c"][1]) / 255.0, float(t["c"][2]) / 255.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Gameboard_tile_changed(tile):
	if tiles.get(tile.x).get(tile.y) == tile.sprite.modulate:
		print_debug("pattern matched")
