extends Node2D

signal combo_complete(keyword, num)
signal tick_update(combos)

var old_tracked = Dictionary()
var tracked = Dictionary()
var patterns_seen = Dictionary()
var pattern_repeated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add(pattern):
	for k in pattern.tags:
		if not tracked.has(k):
			tracked[k] = 0
		tracked[k] += 1
	pattern_repeated = patterns_seen.has(pattern)
	if not pattern_repeated:
		patterns_seen[pattern] = true
	
func tick():
	# if pattern is repeated, mark all combos as completed
	var untracked = Dictionary()
	for t in old_tracked.keys():
		if not tracked.has(t) or pattern_repeated:
			untracked[t] = old_tracked[t]
			old_tracked.erase(t)
			
	for t in tracked.keys():
		if not old_tracked.has(t):
			old_tracked[t] = 0
		old_tracked[t] += tracked[t]
			
	for ut in untracked:
		emit_signal("combo_complete", ut, untracked[ut])
		
	if pattern_repeated:
		pattern_repeated = false
		patterns_seen.clear()
		old_tracked.clear()
	tracked.clear()
	print_debug(old_tracked)
	emit_signal("tick_update", old_tracked)
	
func reset():
	tick()
	tracked.clear()
	patterns_seen.clear()
	old_tracked.clear()
