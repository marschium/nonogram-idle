extends HBoxContainer


var current_combos = Dictionary()


# Called when the node enters the scene tree for the first time.
func _ready():
	Combo.connect("tick_update", self, "_on_Combo_tick_update")
	Combo.connect("combo_complete", self, "_on_Combo_combo_complete")

func _on_Combo_combo_complete(keyword, num):
	if current_combos.has(keyword):
		current_combos[keyword].queue_free()
		current_combos.erase(keyword)
		print_debug("TEST TEST")

func _on_Combo_tick_update(combos):
	current_combos.clear()
	for c in get_children():
		c.queue_free()
	for c in combos.keys():
		var l = Label.new()
		l.text = "%s : %d" % [c, combos[c]]
		add_child(l)
		current_combos[c] = l
