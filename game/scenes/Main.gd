extends Node2D

export var current_color = Color(1, 1, 1)
export var enable_autoclicker = false

onready var autoclicker = $Autoclicker
onready var upgrade_control = $CanvasLayer/UpgradeControl
onready var autoclicker_control = $CanvasLayer/AutoclickerControl
onready var color_control = $CanvasLayer/ColorMenu

func toggle_autoclicker(enabled):
	autoclicker.set_process(enabled)
	autoclicker.stop()
	if enabled:
		autoclicker.start()
	# autoclicker_button.visible = autoclicker.running
	if autoclicker.running:
		$CanvasLayer/AutoclickerControl.autoclicker_running()
	else:
		$CanvasLayer/AutoclickerControl.autoclicker_stopped()
		

# Called when the node enters the scene tree for the first time.
func _ready():
	Score.add(99999)
	Combo.connect("combo_complete", self, "_on_Combo_complete")
	$CanvasLayer/AutoclickerControl.add_color(current_color)
	$CanvasLayer/ColorMenu.add_color(current_color)
	# TODO should the Patterns be responsible for multiplexing?
	toggle_autoclicker(enable_autoclicker)
	for p in $Patterns.get_children():
		$Gameboard.connect("tile_changed", p, "_on_Gameboard_tile_changed")
		$Gameboard.connect("complete", p, "_on_Gameboard_complete")
		$CanvasLayer/AutoclickerControl.add_pattern(p)

func _on_Autoclicker_click(x, y, color):
	$Gameboard.change_dot(x, y, color)    

func _on_Autoclicker_click_any(color):
	$Gameboard.next_unchanged().change(current_color)

func _on_Gameboard_tile_clicked(tile):
	autoclicker.stop()
	$CanvasLayer/AutoclickerControl.autoclicker_stopped()
	tile.change(current_color)

func _on_Gameboard_complete_late():
	var was_autoclicked = autoclicker.running
	autoclicker.stop()
	for p in $Patterns.get_macthes():
		Score.add(p.bonus)
		Combo.add([p.pattern_name])	 # TODO use keywords
	$Patterns.reset_matches()
	Combo.tick()
	$ScoreLabel.text = "dots: %s" % Score.val
	yield(get_tree().create_timer(0.2), "timeout")
	$Gameboard.reset()
	if was_autoclicked:
		autoclicker.start(0, 0)

func _on_UpgradeControl_expand_grid_upgrade(new_size, cost, control):
	if $Upgrades.buy_expand_upgrade(new_size):
		control.queue_free()
		$Gameboard.reset_board(new_size)	

func _on_UpgradeControl_autoclicker_upgrade(new_speed, cost, control):
	if $Upgrades.buy_autoclicker_upgrade(new_speed):
		control.queue_free()
		$CanvasLayer/AutoclickerControl.enable_autoclick()

func _on_UpgradeControl_pattern_upgrade(control):
	# TODO enable the patterns selection screen and active pattern tracking node
	if $Upgrades.buy_patterns_upgrade():
		control.queue_free()
		$CanvasLayer/AutoclickerControl.enable_pattern_select()

func _on_Upgrades_score_increased(new_value):
	$ScoreLabel.text = "dots: %s" % new_value

func _on_Upgrades_expand_board_upgrade_unavailable(size):
	print_debug("unavailable %d" % size)
	upgrade_control.remove_expand_grid_upgrade(size)	

func _on_Upgrades_expand_board_upgrade_available(size, cost):	
	print_debug("available %d" % size)
	upgrade_control.add_expand_grid_upgrade(size, cost)

func _on_Gameboard_tile_changed(tile):
	Score.add(1)
	$ScoreLabel.text = "dots: %s" % Score.val # TODO ScoreLabel can just poll

func _on_Upgrades_expand_board_upgrade_active(size):
	pass

func _on_Upgrades_expand_autoclicker_active(speed):
	pass # Replace with function body.
	
func _on_Upgrades_patterns_active():
	pass

func _on_Upgrades_expand_autoclicker_available(speed, cost):	
	print_debug("available %d" % speed)
	upgrade_control.add_autoclicker_upgrade(speed, cost)

func _on_Upgrades_expand_autoclicker_unavailable(speed):
	# TODO could just setup forwarding on _ready
	print_debug("unavailable %d" % speed)
	upgrade_control.remove_autoclicker_upgrade(speed)	

func _on_Upgrades_patterns_available():
	print_debug("patterns available")
	upgrade_control.add_pattern_upgrade()

func _on_Upgrades_patterns_unavailable():
	upgrade_control.remove_pattern_upgrade()

func _on_Upgrades_color_available(color, cost):	
	print_debug("color available")
	upgrade_control.add_color_upgrade(color, cost)

func _on_UpgradeControl_color_upgrade(color, cost, control):
	if $Upgrades.buy_color_upgrade(color):
		control.queue_free()
		color_control.add_color(color)
		autoclicker_control.add_color(color)

func _on_ColorMenu_color_select(color):
	current_color = color

func _on_AutoclickerControl_autoclick_toggled(enabled):
	if enabled and autoclicker.can_run():
		var d = $Gameboard.next_unchanged()
		autoclicker.start(d.x, d.y)
	else:
		toggle_autoclicker(false)

func _on_AutoclickerControl_pattern_toggled(enabled, pattern):	
	if enabled:
		var d = $Gameboard.next_unchanged() # TODO what if board filled?
		autoclicker.set_pattern(d.x, d.y, pattern)
	else:
		toggle_autoclicker(false)
		autoclicker.clear()
		# TODO disable autoclicker single color for now
		# autoclicker.set_single()


func _on_AutoclickerControl_guide_toggled(enabled, pattern):
	if enabled:
		$Gameboard.show_guide(pattern.tiles)
	else:
		$Gameboard.hide_guide()

func _on_Combo_complete(words, num):
	print("Combo finished")
