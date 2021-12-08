extends Control

signal expand_grid_upgrade(new_size, cost, control)
signal autoclicker_upgrade(new_speed, cost, control)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func add_expand_grid_upgrade(size, cost):
    var b = Button.new()
    b.name = "expand_%s" % size
    b.text = "Expand %d (%d)" % [size, cost]
    b.connect("pressed", self, "_on_ExpandGridButton_pressed", [b, size, cost])
    $ScrollContainer/VBoxContainer.add_child(b)
    
func remove_expand_grid_upgrade(size):
    for b in $ScrollContainer/VBoxContainer.get_children():
        if b.name == "expand_%s" % size: # TODO fix this nightmare
            b.queue_free()
            
func add_autoclicker_upgrade(speed, cost):	
    var b = Button.new()
    b.name = "autoclick_%s" % speed
    b.text = "Autoclicker %d" % [speed]
    b.connect("pressed", self, "_on_AutoclickerButton_pressed", [b, speed, cost])
    $ScrollContainer/VBoxContainer.add_child(b)

func remove_autoclicker_upgrade(size):
    for b in $ScrollContainer/VBoxContainer.get_children():
        if b.name == "autoclick_%s" % size: # TODO fix this nightmare
            b.queue_free()

func _on_ExpandGridButton_pressed(button, new_size, cost):
    emit_signal("expand_grid_upgrade", new_size, cost, button)

func _on_AutoclickerButton_pressed(button, new_speed, cost):
    emit_signal("autoclicker_upgrade", new_speed, cost, button)	
