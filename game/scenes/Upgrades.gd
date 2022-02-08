extends Node2D

signal upgrade_available(info, cost)
signal upgrade_active(info)
signal upgrade_unavailable(info)

signal expand_board_upgrade_available(size, cost, title)
signal expand_board_upgrade_active(size)
signal expand_board_upgrade_unavailable()

signal autoclicker_available(speed, cost, title)
signal autoclicker_active(speed)
signal autoclicker_unavailable(speed)

signal patterns_available(pack_id, cost, title)
signal patterns_unavailable(pack_id)
signal patterns_active(pack_id)


enum UpgradeTag {EXPAND, AUTOCLICK, COLOR, PATTERN}

class UpgradeInfo:
    var available_at = 0
    var cost = 0
    var val = null
    var desc = ""
    
    func _init(a, c, v, d):
        available_at = a
        cost = c
        val = v
        desc = d


# TODO these would be in a save file or something
onready var unavilable_expand_upgrades = []
onready var available_expand_upgrades = []
onready var active_expand_upgrades = []

onready var unavilable_autoclick_upgrades = []
onready var available_autoclick_upgrades = []
onready var active_autoclick_upgrades = []
onready var unavilable_pattern_upgrades = []
onready var available_pattern_upgrades = []
onready var active_pattern_upgrades = []

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
    savedata["upgrades"]["patterns"] = []
    for pid in active_pattern_upgrades:
        savedata["upgrades"]["patterns"].append(pid)

    savedata["upgrades"]["gameboard_sizes"] = []
    for sz in active_expand_upgrades:
        savedata["upgrades"]["gameboard_sizes"].append(sz)
        
    savedata["upgrades"]["autoclicker_speeds"] = []
    for sp in active_autoclick_upgrades:
        savedata["upgrades"]["autoclicker_speeds"].append(sp)

func loadgame(savedata):
    if not savedata.has("upgrades"):
        return
    
    for x in savedata["upgrades"]["gameboard_sizes"]:
        erase(unavilable_expand_upgrades, int(x))
        erase(available_expand_upgrades, int(x))
        active_expand_upgrades.append(int(x))
        emit_signal("expand_board_upgrade_active", int(x))
        
    for x in savedata["upgrades"]["patterns"]:        
        erase(unavilable_pattern_upgrades, int(x))
        erase(available_pattern_upgrades, int(x))
        active_pattern_upgrades.append(int(x))
        emit_signal("patterns_active", int(x))
        
    for x in savedata["upgrades"]["autoclicker_speeds"]:
        erase(unavilable_autoclick_upgrades, int(x))
        erase(available_autoclick_upgrades, int(x))
        active_autoclick_upgrades.append(int(x))
        emit_signal("autoclicker_active", int(x))
        

func _ready():	
    Score.connect("changed", self, "_on_Score_changed")
    unavilable_expand_upgrades.append(UpgradeInfo.new(4, 8, 2, "More Dots"))
    unavilable_expand_upgrades.append(UpgradeInfo.new(16, 32, 3, "More Dots"))
    unavilable_expand_upgrades.append(UpgradeInfo.new(48, 64, 5, "More Dots"))
    unavilable_expand_upgrades.append(UpgradeInfo.new(96, 126, 10, "More Dots"))
    unavilable_autoclick_upgrades.append(UpgradeInfo.new(128, 256, 2, "Auto Dots"))
    unavilable_pattern_upgrades.append(UpgradeInfo.new(16, 16, PatternPacks.PATTERN_PACK.STARTER, "Starter Pack Of Dot Patterns"))
    
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
        emit_signal("expand_board_upgrade_available", e.val, e.cost, e.desc)
        
    if active_pattern_upgrades.has(PatternPacks.PATTERN_PACK.STARTER):
        var autoclick_unlocked = do_upgrade_list(unavilable_autoclick_upgrades)	
        for a in autoclick_unlocked:
            erase(unavilable_autoclick_upgrades, a.val)
            available_autoclick_upgrades.append(a)
            emit_signal("autoclicker_available", a.val, a.cost, a.desc)
        
    # patterns can only be unlocked after grid is largest
    var all_expand_bought = unavilable_expand_upgrades.empty() and available_expand_upgrades.empty()
    if all_expand_bought:
        var pattern_unlocked = do_upgrade_list(unavilable_pattern_upgrades)	
        for c in pattern_unlocked:
            erase(unavilable_pattern_upgrades, c.val)
            available_pattern_upgrades.append(c)
            emit_signal("patterns_available", c.val, c.cost, c.desc)
                

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

func buy_patterns_upgrade(pack_id):
    var info = find(available_pattern_upgrades, pack_id)
    if Score.val < info.cost:
        return false
        
    Score.sub(info.cost)
    erase(available_pattern_upgrades, info.val)
    active_pattern_upgrades.append(info.val)
    emit_signal("patterns_unavailable", info.val)
    emit_signal("patterns_active", info.val)
    return true
