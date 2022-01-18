extends Node2D

signal click(x, y, color)
signal cycle_finished()

export var color = Color(0, 0, 1)

class Click:
	var x = 0
	var y = 0
	var c = null
	
	func _init(x, y, c):
		self.x = x
		self.y = y
		self.c = c

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
	
func sort_clicks(a, b):
	var i = a.y + (a.x * 16)
	var j = b.y + (b.x * 16)
	return i < j
	
func setup():	
	# container for ordered tiles
	var pattern_def = read_json_file(file)
	var w = int(pattern_def["w"])
	var h = int(pattern_def["h"])
	
	# order the tiles
	clicks = []
	for t in pattern_def["tiles"]:
		var i = Click.new(int(t["x"]), int(t["y"]), Color(float(t["c"][0]) / 255.0, float(t["c"][1]) / 255.0, float(t["c"][2]) / 255.0))
		clicks.append(i)
	clicks.sort_custom(self, "sort_clicks")

func start(x, y):
	click_idx = y + (x * 16) # traverse y axis first
	$Timer.start()
	
func resume():
	$Timer.start()
	
func pause():
	$Timer.stop()

func stop():
	$Timer.stop()

func set_pos(x, y):
	click_idx = y + (x * 16)
	
func set_speed(speed):
	$Timer.wait_time = 1.0 / float(speed)
	
func get_current():
	if click_idx >= len(clicks):
		click_idx = 0
	var v = clicks[click_idx]
	return v

# Called when the node enters the scene tree for the first time.
func _ready():
	if file != "":
		setup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Timer_timeout():
	var v = get_current()
	emit_signal("click", v.x, v.y, v.c)
	click_idx += 1
