extends Label

var ScoreToast = preload("res://scenes/ui/ScoreToastControl.tscn")
var offset_x_max = 32
var offset_y_max = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	Score.connect("changed", self, "_on_Score_changed")

func _on_Score_changed(old, new):
	text =  str(new)
	if abs(new - old) <= 1:
		return
	var t = ScoreToast.instance()
	var ox = randi() % offset_x_max
	var oy = randi() % offset_y_max
	t.rect_position = rect_position + Vector2(rect_size.x + ox, oy)
	t.text = str(new - old)
	add_child(t)
