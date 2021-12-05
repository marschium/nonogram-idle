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
	$CanvasLayer/UpgradeControl.add_expand_grid_upgrade(2, 1)
	$CanvasLayer/UpgradeControl.add_expand_grid_upgrade(4, 8)
	$CanvasLayer/UpgradeControl.add_expand_grid_upgrade(8, 32)
	$CanvasLayer/UpgradeControl.add_expand_grid_upgrade(16, 64)
	for p in $Patterns.get_children():
		$Gameboard.connect("tile_changed", p, "_on_Gameboard_tile_changed")
		$Gameboard.connect("complete", p, "_on_Gameboard_complete")
		p.connect("matched", self, "_on_Pattern_matched", [p])

func _on_Gameboard_tile_changed(tile):
	score += 1
	$ScoreLabel.text = "dots: %s" % score

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
	# TODO remove the button/update ui if enough dots
	if score >= cost:
		score -= cost
		control.queue_free()
		$Gameboard.reset_board(new_size)
