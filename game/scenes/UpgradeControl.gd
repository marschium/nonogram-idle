extends Control

enum UpgradeTag {EXPAND, AUTOCLICK, COLOR, PATTERN}

signal expand_grid_upgrade(new_size, cost, control)
signal autoclicker_upgrade(new_speed, cost, control)
signal color_upgrade(color, cost, control)
signal pattern_upgrade(control)

export(NodePath) var upgrades_np = null
var upgrades = upgrades_np

# Called when the node enters the scene tree for the first time.
func _ready():
	upgrades = get_node(upgrades_np)
	upgrades.connect("expand_board_upgrade_available", self, "add_expand_grid_upgrade")
	upgrades.connect("autoclicker_available", self, "add_autoclicker_upgrade")
	upgrades.connect("color_available", self, "add_color_upgrade")
	upgrades.connect("patterns_available", self, "add_pattern_upgrade")
	upgrades.connect("expand_board_upgrade_active", self, "_on_Upgrades_expand_board_upgrade_active")
	upgrades.connect("autoclicker_active", self, "_on_Upgrades_expand_autoclicker_active")
	upgrades.connect("color_active", self, "_on_Upgrades_color_active")
	upgrades.connect("patterns_active", self, "_on_Upgrades_patterns_active")

func add_expand_grid_upgrade(size, cost):
	var b = Button.new()
	b.name = "expand_%s" % size
	b.text = "Expand %d (%d)" % [size, cost]
	b.set_meta("upgrade_tag", UpgradeTag.EXPAND)
	b.set_meta("upgrade_tag_v", size)
	b.connect("pressed", self, "_on_ExpandGridButton_pressed", [b, size, cost])
	$ScrollContainer/VBoxContainer.add_child(b)
	
func remove_buy_button(tag, v):
	for b in $ScrollContainer/VBoxContainer.get_children():
		if b.get_meta("upgrade_tag") == tag and b.get_meta("upgrade_tag_v") == v:
			b.queue_free()
			
func add_autoclicker_upgrade(speed, cost):	
	var b = Button.new()
	b.name = "autoclick_%s" % speed
	b.text = "Autoclicker %d" % [speed]
	b.set_meta("upgrade_tag", UpgradeTag.AUTOCLICK)
	b.set_meta("upgrade_tag_v", speed)
	b.connect("pressed", self, "_on_AutoclickerButton_pressed", [b, speed, cost])
	$ScrollContainer/VBoxContainer.add_child(b)
			
func add_pattern_upgrade():
	var b = Button.new()
	b.name = "pattern"
	b.text = "Autoclicker Patterns"
	b.set_meta("upgrade_tag", UpgradeTag.PATTERN)
	b.set_meta("upgrade_tag_v", null)
	b.connect("pressed", self, "_on_PatternButton_pressed", [b])
	$ScrollContainer/VBoxContainer.add_child(b)
			
func add_color_upgrade(color, cost):	
	var b = Button.new() # TODO Button with texture
	b.name = "color"
	b.text = "Color %s" % [color]	
	b.set_meta("upgrade_tag", UpgradeTag.COLOR)
	b.set_meta("upgrade_tag_v", color)
	b.connect("pressed", self, "_on_ColorButton_pressed", [b, color, cost])
	$ScrollContainer/VBoxContainer.add_child(b)

func _on_ExpandGridButton_pressed(button, new_size, cost):
	upgrades.buy_expand_upgrade(new_size)

func _on_AutoclickerButton_pressed(button, new_speed, cost):
	upgrades.buy_autoclicker_upgrade(new_speed)
	
func _on_PatternButton_pressed(button):
	upgrades.buy_patterns_upgrade()

func _on_ColorButton_pressed(button, color, cost):
	upgrades.buy_color_upgrade(color)

func _on_Upgrades_expand_board_upgrade_active(size):
	remove_buy_button(UpgradeTag.EXPAND, size)

func _on_Upgrades_expand_autoclicker_active(speed):
	remove_buy_button(UpgradeTag.AUTOCLICK, speed)
	
func _on_Upgrades_color_active(color):
	remove_buy_button(UpgradeTag.COLOR, color)
	
func _on_Upgrades_patterns_active():
	remove_buy_button(UpgradeTag.PATTERN, null)
