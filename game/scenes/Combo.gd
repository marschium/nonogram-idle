extends Node2D

signal combo_complete(keyword, num)

var tracked = Dictionary()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func tick(keywords):
	var untracked = Dictionary()
	for t in tracked.keys():
		if not keywords.has(t):
			untracked[t] = tracked[t]
			tracked.erase(t)
		else:
			tracked[t] += 1
			
	for w in keywords:
		if not tracked.has(w):
			tracked[w] = 1
			
	for ut in untracked:
		emit_signal("combo_complete", ut, untracked[ut])
		
	print_debug(tracked)
