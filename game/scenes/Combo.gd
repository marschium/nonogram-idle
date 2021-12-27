extends Node2D

signal combo_complete(keyword, num)
signal tick_update(combos)

var old_tracked = Dictionary()
var tracked = Dictionary()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add(keywords):
	for k in keywords:
		if not tracked.has(k):
			tracked[k] = 0
		tracked[k] += 1
	
func tick():
	var untracked = Dictionary()
	for t in old_tracked.keys():
		if not tracked.has(t):
			untracked[t] = old_tracked[t]
			old_tracked.erase(t)
			
	for t in tracked.keys():
		if not old_tracked.has(t):
			old_tracked[t] = 0
		old_tracked[t] += tracked[t]
			
	for ut in untracked:
		emit_signal("combo_complete", ut, untracked[ut])
		
	tracked.clear()
	print_debug(old_tracked)
	emit_signal("tick_update", old_tracked)
