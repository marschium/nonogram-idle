extends Node2D

signal unlocked(combo)
signal combo_complete(combo)

class PatternComboDef:
    var name = ""
    var bonus_id = ""
    
    var unlocked = false
    var names = []
    var unmatched = []
    
    func _init(name, id, names):
        self.name = name
        self.bonus_id = id
        self.names = names
        self.unmatched = names.duplicate(true)
        
    func on_pattern(name):
        # if name is not in list to match, reset the combo
        if not names.has(name) or not unmatched.has(name):
            reset()
        else:
            unmatched.erase(name)
        
    func is_matched():
        return unmatched.empty()
        
    func reset():
        unmatched = names.duplicate(true)

var definitions = {}

# Called when the node enters the scene tree for the first time.
func _ready():
    definitions["rgb"] = PatternComboDef.new(
        "RGB",
        "RGB",
        ["red"] #, "green", "blue"],
    )
    
    definitions["chicken_coop"] = PatternComboDef.new(
        "Chicken Coop",
        "Chicken Coop",
        ["orange"] #, "green", "blue"],
    )
    
    definitions["stock_market"] = PatternComboDef.new(
        "Stock Market",
        "Stock Market",
        ["white"] #, "green", "blue"],
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
            Bonus.bonus_by_name(d.bonus_id).activate()
            emit_signal("combo_complete", d)
            if not d.unlocked:
                d.unlocked = true
                emit_signal("unlocked", d)
            d.reset()

func reset():
    for n in definitions:
        definitions[n].reset()
