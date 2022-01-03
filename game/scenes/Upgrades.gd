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


# TODO these would be in a save file or something
onready var unavilable_expand_upgrades = {} # size -> cost
onready var available_expand_upgrades = {}  # size -> cost
onready var active_expand_upgrades = []
onready var unavilable_autoclick_upgrades = {} # per sec -> cost
onready var available_autoclick_upgrades = {}  # per sec -> cost
onready var active_autoclick_upgrades = []
onready var unavilable_color_upgrades = {}  # per sec -> cost
onready var available_color_upgrades = {} # per sec -> costcost
onready var active_color_upgrades = []

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
		var x = c.to_html();
		savedata["upgrades"]["colors"].append(c.to_html())

func loadgame(savedata):
	if not savedata.has("upgrades"):
		return
	
	for x in savedata["upgrades"]["gameboard_sizes"]:
		unavilable_expand_upgrades.erase(int(x))
		available_expand_upgrades.erase(int(x))
		active_expand_upgrades.append(int(x))
		emit_signal("expand_board_upgrade_active", x)
		
	if savedata["upgrades"]["patterns_enabled"]:
		patterns_available = true
		patterns_activated = true
		emit_signal("patterns_active")
		
	for x in savedata["upgrades"]["autoclicker_speeds"]:
		unavilable_autoclick_upgrades.erase(int(x))
		available_autoclick_upgrades.erase(int(x))
		active_autoclick_upgrades.append(int(x))
		emit_signal("autoclicker_active", x)
		
	for x in savedata["upgrades"]["colors"]:
		var c = Color(x)
		unavilable_color_upgrades.erase(c)
		available_color_upgrades.erase(c)
		active_color_upgrades.append(c)
		emit_signal("color_active", c)
		

func _ready():	
	Score.connect("changed", self, "_on_Score_changed")
	unavilable_expand_upgrades[2] = 8
	unavilable_expand_upgrades[4] = 16
	unavilable_expand_upgrades[8] = 32
	unavilable_expand_upgrades[16] = 64
	unavilable_autoclick_upgrades[2] = 256
	unavilable_color_upgrades[Color(1, 0, 0)] = 1024
	
func do_upgrade_dict(upgrades):
	var just_unlocked = []
	for sz in upgrades.keys():
		var cost = upgrades[sz]
		if cost <= Score.val:
			just_unlocked.append([sz, cost])
	return just_unlocked

func _on_Score_changed(old, new):
	
	var expand_unlocked = do_upgrade_dict(unavilable_expand_upgrades)
	for sz_cost in expand_unlocked:
		unavilable_expand_upgrades.erase(sz_cost[0])
		available_expand_upgrades[sz_cost[0]] = sz_cost[1]		
		emit_signal("expand_board_upgrade_available", sz_cost[0], sz_cost[1])
		
	# autoclicker only after unlocking patterns
	if patterns_activated:
		var autoclick_unlocked = do_upgrade_dict(unavilable_autoclick_upgrades)	
		for sz_cost in autoclick_unlocked:
			unavilable_autoclick_upgrades.erase(sz_cost[0])
			available_autoclick_upgrades[sz_cost[0]] = sz_cost[1]
			emit_signal("autoclicker_available", sz_cost[0], sz_cost[1])
		
	# colors can only be unlocked after patterns
	if patterns_activated:
		var color_unlocked = do_upgrade_dict(unavilable_color_upgrades)	
		for sz_cost in color_unlocked:
			unavilable_color_upgrades.erase(sz_cost[0])
			available_color_upgrades[sz_cost[0]] = sz_cost[1]
			emit_signal("color_available", sz_cost[0], sz_cost[1])
		
	# patterns can only be unlocked after grid is largest
	var all_expand_bought = unavilable_expand_upgrades.empty() and available_expand_upgrades.empty()
	if not patterns_available and Score.val > pattern_activation_cost and all_expand_bought:
		patterns_available = true
		emit_signal("patterns_available", pattern_activation_cost)
		
func buy_expand_upgrade(size):
	var cost = available_expand_upgrades[size]
	if Score.val < cost:
		return false
	
	Score.sub(cost)

	# disable anything that is smaller
	var just_disabled = []
	for sz in available_expand_upgrades.keys():
		if sz <= size:
			just_disabled.append(sz)
				
	for sz in just_disabled:
		active_expand_upgrades.append(sz)
		available_expand_upgrades.erase(sz)
		emit_signal("expand_board_upgrade_unavailable", sz)
	active_expand_upgrades.append(size)
	emit_signal("expand_board_upgrade_active", size)
	return true

func buy_autoclicker_upgrade(size):
	var cost = available_autoclick_upgrades[size]
	if Score.val < cost:
		return false
	
	Score.sub(cost)
	# disable anything that is slower
	var just_disabled = []
	for sz in available_autoclick_upgrades.keys():
		if sz <= size:
			just_disabled.append(sz)
				
	for sz in just_disabled:
		available_autoclick_upgrades.erase(sz)
		emit_signal("autoclicker_unavailable", sz)
	active_autoclick_upgrades.append(size)
	emit_signal("autoclicker_active", size)
	return true

func buy_patterns_upgrade():
	if Score.val < pattern_activation_cost:
		return false
		
	Score.sub(pattern_activation_cost)
	patterns_activated = true
	emit_signal("patterns_active")
	emit_signal("patterns_unavailable")
	return true

func buy_color_upgrade(color):
	var cost = available_color_upgrades[color]
	if Score.val < cost:
		return false

	Score.sub(cost)
	available_color_upgrades.erase(color)
	emit_signal("color_unavailable", color)
	active_color_upgrades.append(color)
	emit_signal("color_active", color)
	return true
