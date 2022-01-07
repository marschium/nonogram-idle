extends Control

enum UpgradeTag {EXPAND, AUTOCLICK, COLOR, PATTERN}

signal expand_grid_upgrade(new_size, cost, control)
signal autoclicker_upgrade(new_speed, cost, control)
signal color_upgrade(color, cost, control)
signal pattern_upgrade(control)

var UpgradeBuyControl = preload("res://scenes/ui/UpgradeBuyControl.tscn")

export(NodePath) var upgrades_np = null
var upgrades = upgrades_np
var revealed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	upgrades = get_node(upgrades_np)
	upgrades.connect("expand_board_upgrade_available", self, "add_expand_grid_upgrade")
	upgrades.connect("autoclicker_available", self, "add_autoclicker_upgrade")
	upgrades.connect("color_available", self, "add_color_upgrade")
	upgrades.connect("patterns_available", self, "add_pattern_upgrade")
	upgrades.connect("expand_board_upgrade_unavailable", self, "remove_expand_board")
	upgrades.connect("autoclicker_unavailable", self, "remove_autoclicker_speed")
	upgrades.connect("color_unavailable", self, "remove_color")
	upgrades.connect("patterns_unavailable", self, "remove_patterns_active")
	upgrades.connect("expand_board_upgrade_active", self, "remove_expand_board")
	upgrades.connect("autoclicker_active", self, "remove_autoclicker_speed")
	upgrades.connect("color_active", self, "remove_color")
	upgrades.connect("patterns_active", self, "remove_patterns_active")
	
func reveal():
	if not revealed:
		revealed = true
		visible = true
		$AnimationPlayer.play("FadeIn")

func add_expand_grid_upgrade(size, cost):
	reveal()
	var x = UpgradeBuyControl.instance()
	x.title = "Board size increase"
	x.description = "Expand board to %d x %d" % [size, size]
	x.cost = cost
	x.set_meta("upgrade_tag", UpgradeTag.EXPAND)
	x.set_meta("upgrade_tag_v", size)
	$PanelContainer/VBoxContainer.add_child(x)
	x.connect("selected", self, "_on_ExpandGridButton_pressed", [size])
	
func remove_buy_button(tag, v):
	for b in $PanelContainer/VBoxContainer.get_children():
		if b.get_meta("upgrade_tag") == tag and b.get_meta("upgrade_tag_v") == v:
			b.queue_free()
			
func add_autoclicker_upgrade(speed, cost):
	reveal()
	var x = UpgradeBuyControl.instance()
	x.title = "Autoclicker speed increase"
	x.description = "Increase Autoclicker speed to %s dots per second" % [speed]
	x.cost = cost
	x.set_meta("upgrade_tag", UpgradeTag.AUTOCLICK)
	x.set_meta("upgrade_tag_v", speed)
	$PanelContainer/VBoxContainer.add_child(x)
	x.connect("selected", self, "_on_AutoclickerButton_pressed", [speed])
			
func add_pattern_upgrade(cost):
	reveal()
	var x = UpgradeBuyControl.instance()
	x.title = "Enable Patterns"
	x.description = "Matching patterns with dots provides bonuses"
	x.cost = cost
	x.set_meta("upgrade_tag", UpgradeTag.PATTERN)
	x.set_meta("upgrade_tag_v", null)
	$PanelContainer/VBoxContainer.add_child(x)
	x.connect("selected", self, "_on_PatternButton_pressed")
			
func add_color_upgrade(color, cost):
	reveal()
	var x = UpgradeBuyControl.instance() # TODO show color
	x.title = "New dot color"
	x.description = "Create dots in a new color"
	x.cost = cost
	x.set_meta("upgrade_tag", UpgradeTag.COLOR)
	x.set_meta("upgrade_tag_v", color)
	$PanelContainer/VBoxContainer.add_child(x)
	x.connect("selected", self, "_on_ColorButton_pressed", [color])

func _on_ExpandGridButton_pressed(new_size):
	upgrades.buy_expand_upgrade(new_size)

func _on_AutoclickerButton_pressed(new_speed):
	upgrades.buy_autoclicker_upgrade(new_speed)
	
func _on_PatternButton_pressed():
	upgrades.buy_patterns_upgrade()

func _on_ColorButton_pressed(color):
	upgrades.buy_color_upgrade(color)

func remove_expand_board(size):
	remove_buy_button(UpgradeTag.EXPAND, size)

func remove_autoclicker_speed(speed):
	remove_buy_button(UpgradeTag.AUTOCLICK, speed)
	
func remove_color(color):
	remove_buy_button(UpgradeTag.COLOR, color)
	
func remove_patterns_active():
	remove_buy_button(UpgradeTag.PATTERN, null)
