extends Node2D

signal expand_board_upgrade_available(size, cost)
signal expand_board_upgrade_active(size)
signal expand_board_upgrade_unavailable()

signal autoclicker_available(speed, cost)
signal autoclicker_active(speed)
signal autoclicker_unavailable(speed)

signal color_available(color, cost)
signal color_active(color)
signal color_unavailable(color)

signal patterns_available(cost)
signal patterns_unavailable()
signal patterns_active()

var patterns_available = false
var patterns_activated = false
var pattern_activation_cost = 96

class UpgradeInfo:
    var available_at = 0
    var cost = 0
    var val = null
    
    func _init(a, c, v):
        available_at = a
        cost = c
        val = v


# TODO these would be in a save file or something
onready var unavilable_expand_upgrades = []
onready var available_expand_upgrades = []
onready var active_expand_upgrades = []

onready var unavilable_autoclick_upgrades = []
onready var available_autoclick_upgrades = []
onready var active_autoclick_upgrades = []

onready var unavilable_color_upgrades = []
onready var available_color_upgrades = []
onready var active_color_upgrades = []

func find(upgrade_list, val):
    var i = -1
    for x in len(upgrade_list):
        if upgrade_list[x].val == val:
            i = x
            break
    if i != -1:
        return upgrade_list[i]
    return null
        

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
    savedata["upgrades"]["patterns_enabled"] = patterns_activated

    savedata["upgrades"]["gameboard_sizes"] = []
    for sz in active_expand_upgrades:
        savedata["upgrades"]["gameboard_sizes"].append(sz)
        
    savedata["upgrades"]["autoclicker_speeds"] = []
    for sp in active_autoclick_upgrades:
        savedata["upgrades"]["autoclicker_speeds"].append(sp)
        
    savedata["upgrades"]["colors"] = []
    for c in active_color_upgrades:
        savedata["upgrades"]["colors"].append(c.to_html())

func loadgame(savedata):
    if not savedata.has("upgrades"):
        return
    
    for x in savedata["upgrades"]["gameboard_sizes"]:
        erase(unavilable_expand_upgrades, int(x))
        erase(available_expand_upgrades, int(x))
        active_expand_upgrades.append(int(x))
        emit_signal("expand_board_upgrade_active", x)
        
    if savedata["upgrades"]["patterns_enabled"]:
        patterns_available = true
        patterns_activated = true
        emit_signal("patterns_active")
        
    for x in savedata["upgrades"]["autoclicker_speeds"]:
        erase(unavilable_autoclick_upgrades, int(x))
        erase(available_autoclick_upgrades, int(x))
        active_autoclick_upgrades.append(int(x))
        emit_signal("autoclicker_active", x)
        
    for x in savedata["upgrades"]["colors"]:
        var c = Color(x)
        erase(unavilable_color_upgrades, c)
        erase(available_color_upgrades, c)
        active_color_upgrades.append(c)
        emit_signal("color_active", c)
        

func _ready():	
    Score.connect("changed", self, "_on_Score_changed")
    unavilable_expand_upgrades.append(UpgradeInfo.new(4, 8, 2))
    unavilable_expand_upgrades.append(UpgradeInfo.new(16, 32, 4))
    unavilable_expand_upgrades.append(UpgradeInfo.new(48, 64, 8))
    unavilable_expand_upgrades.append(UpgradeInfo.new(96, 126, 16))
    unavilable_autoclick_upgrades.append(UpgradeInfo.new(128, 256, 2))
    unavilable_color_upgrades.append(UpgradeInfo.new(512, 1024, Color("#ff0000")))
    unavilable_color_upgrades.append(UpgradeInfo.new(1024, 2024, Color("#0000ff")))
    unavilable_color_upgrades.append(UpgradeInfo.new(2024, 3024, Color("00ff00")))
    unavilable_color_upgrades.append(UpgradeInfo.new(2024, 3024, Color("#3399ff")))
    
func do_upgrade_list(upgrades):
    var just_unlocked = []
    for i in upgrades:
        if i.available_at <= Score.val:
            just_unlocked.append(i)
    return just_unlocked


func _on_Score_changed(old, new):
    
    var expand_unlocked = do_upgrade_list(unavilable_expand_upgrades)
    for e in expand_unlocked:
        erase(unavilable_expand_upgrades, e.val)
        available_expand_upgrades.append(e)
        emit_signal("expand_board_upgrade_available", e.val, e.cost)
        
    if patterns_activated:
        var autoclick_unlocked = do_upgrade_list(unavilable_autoclick_upgrades)	
        for a in autoclick_unlocked:
            erase(unavilable_autoclick_upgrades, a.val)
            available_autoclick_upgrades.append(a)
            emit_signal("autoclicker_available", a.val, a.cost)
        
    # colors can only be unlocked after patterns
    if patterns_activated:
        var color_unlocked = do_upgrade_list(unavilable_color_upgrades)	
        for c in color_unlocked:
            erase(unavilable_color_upgrades, c.val)
            available_color_upgrades.append(c)
            emit_signal("color_available", c.val, c.cost)
        
    # patterns can only be unlocked after grid is largest
    var all_expand_bought = unavilable_expand_upgrades.empty() and available_expand_upgrades.empty()
    if not patterns_available and Score.val > pattern_activation_cost and all_expand_bought:
        patterns_available = true
        emit_signal("patterns_available", pattern_activation_cost)
        
func buy_expand_upgrade(size):
    var info = find(available_expand_upgrades, size)
    if Score.val < info.cost:
        return false
    
    Score.sub(info.cost)

    # disable anything that is smaller
    var just_disabled = []
    for a in available_expand_upgrades:
        if a.val <= info.val:
            just_disabled.append(a)
                
    for a in just_disabled:
        active_expand_upgrades.append(a.val)
        erase(available_expand_upgrades, a.val)
        emit_signal("expand_board_upgrade_unavailable", a.val)
    active_expand_upgrades.append(info.val)
    emit_signal("expand_board_upgrade_active", info.val)
    return true

func buy_autoclicker_upgrade(speed):
    var info = find(available_autoclick_upgrades, speed)
    if Score.val < info.cost:
        return false
    
    Score.sub(info.cost)
    # disable anything that is slower
    var just_disabled = []
    for a in available_autoclick_upgrades:
        if a.val <= info.val:
            just_disabled.append(a)
                
    for a in just_disabled:
        erase(available_autoclick_upgrades, a.val)
        emit_signal("autoclicker_unavailable", a.val)
    active_autoclick_upgrades.append(info.val)
    emit_signal("autoclicker_active", info.val)
    return true

func buy_patterns_upgrade():
    if Score.val < pattern_activation_cost:
        return false
        
    Score.sub(pattern_activation_cost)
    patterns_activated = true
    emit_signal("patterns_unavailable")
    emit_signal("patterns_active")
    return true

func buy_color_upgrade(color):
    var info = find(available_color_upgrades, color)
    if Score.val < info.cost:
        return false

    Score.sub(info.cost)
    erase(available_color_upgrades, info.val)
    emit_signal("color_unavailable", info.val)
    active_color_upgrades.append(info.val)
    emit_signal("color_active", info.val)
    return true
