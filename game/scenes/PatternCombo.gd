extends Node2D

signal unlocked(name)
signal combo_complete(name)

class PatternComboDef:
	var unlocked = false
	var names = []
	var unmatched = []
	func _init(names):
		self.names = names
		self.unmatched = names
		
	func on_pattern(name):
		unmatched.erase(name)
		
	func is_matched():
		return unmatched.empty()
		
	func reset():
		unmatched = names

var unmatched = ["cloud", "snowflake"]
var unlocked = false
var definitions = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	definitions["winter"] = PatternComboDef.new(["cloud", "snowflake"])
	
func loadgame(data):
	if not data.has("combos"):
		return
	for n in data["combos"]:
		definitions[n].unlocked = true

func savegame(data):
	data["combos"] = []
	for n in definitions:
		if definitions[n].unlocked:
			data["combos"].append(n)

func add(pattern):
	for n in definitions:
		var d = definitions[n]
		d.on_pattern(pattern.pattern_name)
		if d.is_matched():
			emit_signal("combo_complete", n)
			if not d.unlocked:
				d.unlocked = true
				emit_signal("unlocked", n)

func reset():
	for n in definitions:
		definitions[n].reset()
