extends Node2D

signal score_increased(new_value)

signal expand_board_upgrade_available(size, cost)
signal expand_board_upgrade_active(size)
signal expand_board_upgrade_unavailable()

signal autoclicker_available(speed, cost)
signal autoclicker_active(speed)
signal autoclicker_unavailable(speed)

signal color_available(color, cost)
signal color_active(color)
signal color_unavailable(color)

# TODO parameterize with pattern file/def?
# TODO maybe have patterns stored somewhere else?
signal patterns_available()
signal patterns_unavailable()
signal patterns_active()

var patterns_available = false
var patterns_activated = false
var pattern_activation_cost = 96


# TODO these would be in a save file or something
var unavilable_expand_upgrades = Dictionary()  # size -> cost
var available_expand_upgrades = Dictionary()  # size -> cost
var unavilable_autoclick_upgrades = Dictionary()  # per sec -> cost
var available_autoclick_upgrades = Dictionary()  # per sec -> cost
var unavilable_color_upgrades = Dictionary()  # per sec -> cost
var available_color_upgrades = Dictionary()  # per sec -> cost

func loadgame(savedata):
	for x in savedata["upgrades"]["size"]:
		unavilable_expand_upgrades.erase(x)
		available_expand_upgrades.erase(x)
		emit_signal("expand_board_upgrade_active", x)

func _ready():	
	Score.connect("changed", self, "_on_Score_changed")
	unavilable_expand_upgrades[2] = 8
	unavilable_expand_upgrades[4] = 16
	unavilable_expand_upgrades[8] = 32
	unavilable_expand_upgrades[16] = 64
	unavilable_autoclick_upgrades[1] = 256
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
		emit_signal("patterns_available")
		
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
		available_expand_upgrades.erase(sz)
		emit_signal("expand_board_upgrade_unavailable", sz)
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
		emit_signal("expand_autoclicker_unavailable", sz)
	emit_signal("expand_autoclicker_active", size)
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
	emit_signal("color_active", color)
	return true
