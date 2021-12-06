extends Control

signal expand_grid_upgrade(new_size)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func add_expand_grid_upgrade(size, cost):
	var b = Button.new()
	b.name = "%s" % size
	b.text = "Expand %d (%d)" % [size, cost]
	b.connect("pressed", self, "_on_ExpandGridButton_pressed", [b, size, cost])
	$ScrollContainer/VBoxContainer.add_child(b)
	
func remove_expand_grid_upgrade(size):
	for b in $ScrollContainer/VBoxContainer.get_children():
		if b.name == "%s" % size:
			b.queue_free()

func _on_ExpandGridButton_pressed(button, new_size, cost):
	emit_signal("expand_grid_upgrade", new_size, cost, button)

