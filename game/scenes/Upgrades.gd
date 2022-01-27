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

signal patterns_available(pack_id, cost)
signal patterns_unavailable(pack_id)
signal patterns_active(pack_id)

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
        
    savedata["upgrades"]["colors"] = []
    for c in active_color_upgrades:
        savedata["upgrades"]["colors"].append(c)

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
        
    for x in savedata["upgrades"]["colors"]:
        erase(unavilable_color_upgrades, int(x))
        erase(available_color_upgrades, int(x))
        if not active_color_upgrades.has(int(x)):
            active_color_upgrades.append(int(x))
            emit_signal("color_active", int(x))
        

func _ready():	
    Score.connect("changed", self, "_on_Score_changed")
    unavilable_expand_upgrades.append(UpgradeInfo.new(4, 8, 2))
    unavilable_expand_upgrades.append(UpgradeInfo.new(16, 32, 3))
    unavilable_expand_upgrades.append(UpgradeInfo.new(48, 64, 5))
    unavilable_expand_upgrades.append(UpgradeInfo.new(96, 126, 10))
    unavilable_autoclick_upgrades.append(UpgradeInfo.new(128, 256, 2))
    unavilable_color_upgrades.append(UpgradeInfo.new(16, 16, ColorPacks.COLOR_PACK.BASIC))
    unavilable_pattern_upgrades.append(UpgradeInfo.new(16, 16, PatternPacks.PATTERN_PACK.STARTER))
    
    if not active_color_upgrades.has(ColorPacks.COLOR_PACK.WHITE):
        available_color_upgrades.append(UpgradeInfo.new(0, 0, ColorPacks.COLOR_PACK.WHITE))
    
    
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
        
    if active_pattern_upgrades.has(PatternPacks.PATTERN_PACK.STARTER):
        var autoclick_unlocked = do_upgrade_list(unavilable_autoclick_upgrades)	
        for a in autoclick_unlocked:
            erase(unavilable_autoclick_upgrades, a.val)
            available_autoclick_upgrades.append(a)
            emit_signal("autoclicker_available", a.val, a.cost)
        
    var color_unlocked = do_upgrade_list(unavilable_color_upgrades)	
    for c in color_unlocked:
        erase(unavilable_color_upgrades, c.val)
        available_color_upgrades.append(c)
        emit_signal("color_available", c.val, c.cost)
        
    # patterns can only be unlocked after grid is largest and basic colors
    if active_color_upgrades.has(ColorPacks.COLOR_PACK.BASIC):
        var all_expand_bought = unavilable_expand_upgrades.empty() and available_expand_upgrades.empty()
        if all_expand_bought:
            var pattern_unlocked = do_upgrade_list(unavilable_pattern_upgrades)	
            for c in pattern_unlocked:
                erase(unavilable_pattern_upgrades, c.val)
                available_pattern_upgrades.append(c)
                emit_signal("patterns_available", c.val, c.cost)
                

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

func buy_color_upgrade(color_id):
    var info = find(available_color_upgrades, color_id)
    if info == null:
        return false
    if Score.val < info.cost:
        return false

    Score.sub(info.cost)
    erase(available_color_upgrades, info.val)
    active_color_upgrades.append(info.val)
    emit_signal("color_unavailable", info.val)
    emit_signal("color_active", info.val)
    return true
