extends Node2D

onready var UpgradeInfo = preload("res://scenes/UpgradeInfo.tscn")
        

func erase(upgrade_list, val):
    var i = -1
    for x in len(upgrade_list):
        if upgrade_list[x].val == val:
            i = x
            break
    if i != -1:
        upgrade_list.remove(i)

func savegame(savedata):
    savedata["upgrades"] = {}
    savedata["upgrades"]["expand"] = []
    savedata["upgrades"]["pattern"] = []
    savedata["upgrades"]["auto"] = []
    for upgrade in get_children():
        upgrade.savegame(savedata)

func loadgame(savedata):
    if not savedata.has("upgrades"):
        return    
    for upgrade in get_children():
        upgrade.loadgame(savedata)
     
func add_upgrade(available_at, cost, val, desc, tag):
    var u = UpgradeInfo.instance()
    u.setup(available_at, cost, val, desc, tag)
    add_child(u)
    return u

func _ready():	
    var a = add_upgrade(4, 8, 2, "More Dots", "expand")
    var b = add_upgrade(16, 32, 3, "More Dots", "expand")
    var c = add_upgrade(48, 64, 5, "More Dots", "expand")
    var largest_board = add_upgrade(96, 126, 10, "More Dots", "expand")  
    b.set_condition("a_board") 
    c.set_condition("b_board") 
    largest_board.set_condition("c_board") 
    a.connect("active", b, "remove_condition", ["a_board"])
    b.connect("active", c, "remove_condition", ["b_board"])
    c.connect("active", largest_board, "remove_condition", ["c_board"])
    
    var basic_pattern = add_upgrade(16, 16, PatternPacks.PATTERN_PACK.STARTER, "Starter Pack Of Dot Patterns", "pattern")
    basic_pattern.set_condition("max_board_size")    
    largest_board.connect("active", basic_pattern, "remove_condition", ["max_board_size"])
    var farm_pattern = add_upgrade(32, 32, PatternPacks.PATTERN_PACK.FARM, "Collection of farmyard patterns", "pattern")
    farm_pattern.set_condition("basic")
    basic_pattern.connect("active", farm_pattern, "remove_condition", ["basic"])
    
    var auto = add_upgrade(128, 256, 2, "Auto Dots", "auto")
    auto.set_condition("basic_pattern")    
    basic_pattern.connect("active", auto, "remove_condition", ["basic_pattern"])


func buy_patterns_upgrade(pack_id):
    pass
