extends Control

signal expand_grid_upgrade(new_size)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func add_expand_grid_upgrade(size):
	var b = Button.new()
	b.text = "Expand %d" % size
	b.toggle_mode = true
	b.connect("toggled", self, "_on_ExpandGridButton_toggled", [b, size])
	$ScrollContainer/VBoxContainer.add_child(b)

func _on_ExpandGridButton_toggled(button_pressed, button, new_size):
	button.queue_free()
	emit_signal("expand_grid_upgrade", new_size)

