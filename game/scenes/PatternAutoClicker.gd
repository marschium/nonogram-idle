extends Node2D

signal click(x, y, color)

export var color = Color(0, 0, 1)

var file = ""
var w = 16
var clicks = []
var click_idx = 0
var pattern = null

func clear():
	file = ""
	click_idx = 0
	clicks = []

func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	return content_as_dictionary
	
func setup():	
	# container for ordered tiles
	var pattern_def = read_json_file(file)
	var w = int(pattern_def["w"])
	var h = int(pattern_def["h"])
	
	# order the tiles
	clicks = []
	clicks.resize(w * h)
	for t in pattern_def["tiles"]:
		var x = int(t["x"])
		var y = int(t["y"])
		clicks[y + (x * 16)] = [x, y, Color(float(t["c"][0]) / 255.0, float(t["c"][1]) / 255.0, float(t["c"][2]) / 255.0)]

func start(x, y):
	click_idx = y + (x * 16) # traverse y axis first
	$Timer.start()

func stop():
	$Timer.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	if file != "":
		setup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Timer_timeout():
	if click_idx >= len(clicks):
		click_idx = 0
	var v = clicks[click_idx]
	emit_signal("click", v[0], v[1], v[2])
	click_idx += 1
