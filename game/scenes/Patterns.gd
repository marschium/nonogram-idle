extends Node2D


var Pattern = preload("res://scenes/Pattern.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
    # TODO iterate the folder
    var p = Pattern.instance()
    p.file = "res://patterns/red.json"
    add_child(p)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
