extends PanelContainer

var pattern = null
var PatternTagLabel = preload("res://scenes/ui/PatternTagLabel.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/VBoxContainer/TextureRect.texture = load("res://images/%s.png" % [pattern.pattern_name])
	$CenterContainer/VBoxContainer/NameLabel.text = pattern.pattern_name
	for tag in pattern.tags:
		var p = PatternTagLabel.instance()
		p.text = tag
		$CenterContainer/VBoxContainer/TagsHBoxContainer.add_child(p)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	queue_free()
