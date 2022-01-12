extends Node2D

signal bonus_active(name)
signal bonus_inactive(name)

var active_bonuses = []

# Called when the node enters the scene tree for the first time.
func _ready():
	PatternCombo.connect("combo_complete", self, "_on_PatternCombo_combo_complete")
	pass # Replace with function body.
	
func get_bonus(pattern):
	var bonus = 0
	for tag in pattern.tags:
		if active_bonuses.has(tag):
			bonus += pattern.num_tiles * 2
	return bonus


func _on_PatternCombo_combo_complete(name):
	# TODO start a timer
	if not active_bonuses.has(name):
		active_bonuses.append(name)
		emit_signal("bonus_active", name)
