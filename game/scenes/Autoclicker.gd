extends Node2D

signal click(x, y, color)

export var running = false
export var color = Color(0, 0, 1)

var file = "res://example.json"
var clicks = []
var click_idx = 0

func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary

func start():
	$Timer.start()

func stop():
	$Timer.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# container for ordered tiles
	var pattern_def = read_json_file(file)
	var w = int(pattern_def["w"])
	var h = int(pattern_def["h"])
	var tiles = []
	tiles.resize(w)
	for x in w:
		var c = []
		c.resize(h)
		tiles[x] = c
	
	# order the tiles
	for t in pattern_def["tiles"]:
		var x = int(t["x"])
		var y = int(t["y"])
		tiles[x][y] = Color(float(t["c"][0]) / 255.0, float(t["c"][1]) / 255.0, float(t["c"][2]) / 255.0)

	click_idx = 0
	clicks = []
	for x in range(w):
		for y in range(h):
			clicks.append([x, y, tiles[x][y]])

	if running:
		$Timer.start()
	else:
		$Timer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Timer_timeout():
	if click_idx >= len(clicks):
		click_idx = 0
	var v = clicks[click_idx]
	emit_signal("click", v[0], v[1], v[2])
	click_idx += 1
