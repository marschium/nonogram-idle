extends Node2D

var pattern_dir = "res://patterns"
var Pattern = preload("res://scenes/Pattern.tscn")

var matched = []

func savegame(savedata):
	savedata["patterns"] = []
	for c in get_children():
		if c.unlocked:
			savedata["patterns"].append(c.pattern_name)

func loadgame(savedata):
	for x in savedata.get("patterns", []):
		for c in get_children():
			if c.pattern_name == x:
				c.unlock(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	var d = Directory.new()
	d.open(pattern_dir)
	d.list_dir_begin()
	var f = d.get_next()
	var i = 0
	while f != "":
		if f != "." and f != ".." and not d.current_is_dir():
			print_debug(f)
			i += 1
			var p = Pattern.instance()
			p.file = d.get_current_dir() + "/" + f
			p.connect("matched", self, "_on_Pattern_matched", [p])
			add_child(p)
		f = d.get_next()

	
func _on_Pattern_matched(bonus, pattern):
	matched.append(pattern)

func get_matches():
	return matched
	
func reset_matches():
	matched = []
