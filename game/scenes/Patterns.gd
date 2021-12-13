extends Node2D


var pattern_dir = "res://patterns"
var Pattern = preload("res://scenes/Pattern.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var d = Directory.new()
	d.open(pattern_dir)
	d.list_dir_begin()
	var f = d.get_next()
	var i = 0
	while f != "":
		if f != "." and f != ".." and not d.current_is_dir():
			print_debug(f)
			i += 1
			var p = Pattern.instance()
			p.file = d.get_current_dir() + "/" + f
			add_child(p)
		f = d.get_next()

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
