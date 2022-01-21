extends Node2D

signal unlocked(combo)
signal combo_complete(combo)

class PatternComboDef:
    var name = ""
    var desc = ""
    var unlocked = false
    var names = []
    var unmatched = []
    func _init(name, desc, names):
        self.name = name
        self.desc = desc
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
    definitions["winter"] = PatternComboDef.new(
        "winter",
        "2x Multipler For Winter Tags",
        ["cloud", "snowflake"]
    )
    
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
            emit_signal("combo_complete", d)
            if not d.unlocked:
                d.unlocked = true
                emit_signal("unlocked", d)

func reset():
    for n in definitions:
        definitions[n].reset()
