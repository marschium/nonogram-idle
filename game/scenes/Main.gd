extends Node2D


var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AutoclickerButton.pressed = $Autoclicker.running
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
	tile.change(Color(1, 0, 0))

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
