extends Node2D

signal score_increased(new_value)
signal expand_board_upgrade_available(size, cost)
signal expand_board_upgrade_active(size, cost)
signal expand_board_upgrade_unavailable(size)


var score = 0
# TODO these would be in a save file or something
var unavilable_expand_upgrades = Dictionary()  # size -> cost
var available_expand_upgrades = Dictionary()  # size -> cost

func _ready():	
	unavilable_expand_upgrades[2] = 1
	unavilable_expand_upgrades[4] = 8
	unavilable_expand_upgrades[8] = 32
	unavilable_expand_upgrades[16] = 64

func increase_score():	
	score += 1
	emit_signal("score_increased", score)
	
	var just_added = []
	var biggest_unlocked = -1
	for sz in unavilable_expand_upgrades.keys():
		var cost = unavilable_expand_upgrades[sz]
		if cost <= score:
			just_added.append([sz, cost])
			if sz > biggest_unlocked:
				biggest_unlocked = sz
			
	for sz_cost in just_added:
		unavilable_expand_upgrades.erase(sz_cost[0])
		available_expand_upgrades[sz_cost[0]] = sz_cost[1]
		emit_signal("expand_board_upgrade_available", sz_cost[0], sz_cost[1])
		
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
