extends Node2D

var BonusEntry = preload("res://scenes/ui/BonusStatsMenuEntry.tscn")
onready var container = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
    for b in Bonus.get_children():
        var c = BonusEntry.instance()
        c.bonus = b
        container.add_child(c)
    $DraggableWindow.set_title("Bonus Stats")
    $DraggableWindow.repack() 
