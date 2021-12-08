extends Node2D

signal score_increased(new_value)

signal expand_board_upgrade_available(size, cost)
signal expand_board_upgrade_active(size, cost)
signal expand_board_upgrade_unavailable(size)

signal expand_autoclicker_available(speed, cost)
signal expand_autoclicker_active(speed, cost)
signal expand_autoclicker_unavailable(speed)

var score = 0
# TODO these would be in a save file or something
var unavilable_expand_upgrades = Dictionary()  # size -> cost
var available_expand_upgrades = Dictionary()  # size -> cost
var unavilable_autoclick_upgrades = Dictionary()  # per sec -> cost
var available_autoclick_upgrades = Dictionary()  # per sec -> cost

func _ready():	
	unavilable_expand_upgrades[2] = 32
	unavilable_expand_upgrades[4] = 64
	unavilable_expand_upgrades[8] = 128
	unavilable_expand_upgrades[16] = 256
	unavilable_autoclick_upgrades[1] = 8
	
func do_upgrade_dict(upgrades):
	var just_unlocked = []
	for sz in upgrades.keys():
		var cost = upgrades[sz]
		if cost <= score:
			just_unlocked.append([sz, cost])
	return just_unlocked

func increase_score():	
	score += 1
	emit_signal("score_increased", score)
	
	var expand_unlocked = do_upgrade_dict(unavilable_expand_upgrades)
	for sz_cost in expand_unlocked:
		unavilable_expand_upgrades.erase(sz_cost[0])
		available_expand_upgrades[sz_cost[0]] = sz_cost[1]
		emit_signal("expand_board_upgrade_available", sz_cost[0], sz_cost[1])
		
	var autoclick_unlocked = do_upgrade_dict(unavilable_autoclick_upgrades)	
	for sz_cost in autoclick_unlocked:
		unavilable_autoclick_upgrades.erase(sz_cost[0])
		available_autoclick_upgrades[sz_cost[0]] = sz_cost[1]
		emit_signal("expand_autoclicker_available", sz_cost[0], sz_cost[1])
		
func buy_expand_upgrade(size):
	var cost = available_expand_upgrades[size]
	if score < cost:
		return false
	
	score -= cost
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
