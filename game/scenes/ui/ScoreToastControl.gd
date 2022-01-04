extends Label


var font_max = 32
var font_min = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	var v = int(text)
	if v > 0:
		text = "+%s" % [v]
	var f = 16 + ((abs(v) / 512.0) * 64)
	get("custom_fonts/font").set_size(32) # TODO change size
	$AnimationPlayer.play("ScoreToastAnimation")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
