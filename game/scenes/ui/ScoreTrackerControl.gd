extends Label

var ScoreToast = preload("res://scenes/ui/ScoreToastControl.tscn")
var offset_x_max = 32
var offset_y_max = 16

# Called when the node enters the scene tree for the first time.
func _ready():
    Score.connect("changed", self, "_on_Score_changed")

func _on_Score_changed(old, new):
    text =  str(new)
