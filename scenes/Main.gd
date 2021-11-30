extends Node2D


var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Gameboard_tile_changed(tile):
	score += 1
	$ScoreLabel.text = "dots: %s" % score

func _on_Autoclicker_click(color):
	var t = $Gameboard.next_unchanged()
	if t != null:
		t.change(color)

func _on_Gameboard_tile_clicked(tile):
	tile.change(Color(0, 1, 0))

func _on_Gameboard_complete():
	yield(get_tree().create_timer(0.2), "timeout")
	$Gameboard.reset()
