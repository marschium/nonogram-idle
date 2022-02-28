extends Node2D

signal unlocked(combo)
signal combo_complete(combo)

class Nothing:
    func get_pattern_bonus(pattern):
        return 0

class MultiplyTag:
    var val = 1
    var tag = ""
    
    func _init(val, tag):
        self.val = val
    
    func get_pattern_bonus(pattern):
        if pattern.tags.has(tag):
            return pattern.num_tiles * self.val
        return 0

class PatternComboDef:
    var name = ""
    var desc = ""
    var duration = 0
    var effect = null
    var bonus_id = ""
    
    var unlocked = false
    var names = []
    var unmatched = []
    
    func _init(name, id, desc, names, effect, duration=600):
        self.name = name
        self.bonus_id = id
        self.desc = desc
        self.names = names
        self.duration = duration
        self.effect = effect
        self.unmatched = names.duplicate(true)
        
    func on_pattern(name):
        unmatched.erase(name)
        
    func is_matched():
        return unmatched.empty()
        
    func reset():
        unmatched = names.duplicate(true)

var definitions = {}

# Called when the node enters the scene tree for the first time.
func _ready():
    definitions["winter"] = PatternComboDef.new(
        "winter", "winter",
        "2x Multipler For Winter Tags",
        ["cloud", "snowflake"],
        MultiplyTag.new(2, "winter"),
        30
    )
    definitions["rgb"] = PatternComboDef.new(
        "RGB", "rgb",
        "10% Extra For Colors",
        ["red"], #, "green", "blue"],
        MultiplyTag.new(0.1, "color"),
        30
    )
    definitions["chicken_coop"] = PatternComboDef.new(
        "Chicken Coop", "chicken_coop",
        "Activates the chicken coop",
        ["orange"], #, "green", "blue"],
        Nothing.new(),
        300
    )
    
    definitions["stock_market"] = PatternComboDef.new(
        "Stock Market", "stock_market",
        "Activates the stock market",
        ["white"], #, "green", "blue"],
        Nothing.new(),
        300
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
