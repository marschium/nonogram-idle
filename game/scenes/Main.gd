extends Node2D

export var enable_autoclicker = false

var score = 0


func toggle_autoclicker(enabled):
	$Autoclicker.set_process(enabled)
	$AutoclickerButton.set_process(enabled)
	$Autoclicker.stop()
	if enabled:
		$Autoclicker.start()
	$AutoclickerButton.visible = $Autoclicker.running
	$AutoclickerButton.pressed = $Autoclicker.running

# Called when the node enters the scene tree for the first time.
func _ready():
	toggle_autoclicker(enable_autoclicker)
	for p in $Patterns.get_children():
		$Gameboard.connect("tile_changed", p, "_on_Gameboard_tile_changed")
		$Gameboard.connect("complete", p, "_on_Gameboard_complete")
		p.connect("matched", self, "_on_Pattern_matched", [p])

func _on_Autoclicker_click(x, y, color):
	$Gameboard.change_dot(x, y, color)

func _on_Gameboard_tile_clicked(tile):
	$Autoclicker.stop()
	$AutoclickerButton.pressed = false
	tile.change(Color(1, 0, 0)) # TODO brush color

func _on_Gameboard_complete():
	$Autoclicker.stop()
	yield(get_tree().create_timer(0.2), "timeout")
	$Gameboard.reset()
	if $AutoclickerButton.pressed:
		$Autoclicker.start(0, 0)

func _on_AutoclickerButton_toggled(button_pressed):
	if button_pressed:
		var d = $Gameboard.next_unchanged()
		$Autoclicker.start(d.x, d.y)
	else:
		$Autoclicker.stop()
		
func _on_Pattern_matched(bonus, pattern):
	score += bonus
	$ScoreLabel.text = "dots: %s" % score

func _on_UpgradeControl_expand_grid_upgrade(new_size, cost, control):
	if $Upgrades.buy_expand_upgrade(new_size):
		control.queue_free()
		$Gameboard.reset_board(new_size)	

func _on_Upgrades_score_increased(new_value):
	$ScoreLabel.text = "dots: %s" % new_value

func _on_Upgrades_expand_board_upgrade_unavailable(size):
	print_debug("unavailable %d" % size)
	$CanvasLayer/UpgradeControl.remove_expand_grid_upgrade(size)	

func _on_Upgrades_expand_board_upgrade_available(size, cost):	
	print_debug("available %d" % size)
	$CanvasLayer/UpgradeControl.add_expand_grid_upgrade(size, cost)

func _on_Gameboard_tile_changed(tile):
	$Upgrades.increase_score()

func _on_Upgrades_expand_board_upgrade_active(size, cost):
	pass

func _on_Upgrades_expand_autoclicker_active(speed, cost):
	pass # Replace with function body.

func _on_Upgrades_expand_autoclicker_available(speed, cost):	
	print_debug("available %d" % speed)

func _on_Upgrades_expand_autoclicker_unavailable(speed):
	print_debug("unavailable %d" % speed)
