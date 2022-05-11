extends Control


export var VIEW_FULLSCREEN = 0
export var VIEW_STATS = 1

onready var StatsWindow = preload("res://scenes/ui/BonusStatsMenu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
    $PanelContainer/MarginContainer/HBoxContainer/ViewMenuButton.get_popup().connect("id_pressed", self, "_on_ViewMenuButtonPopup_id_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_ViewMenuButtonPopup_id_pressed(id):
    if id == VIEW_FULLSCREEN:
        OS.window_fullscreen = !OS.window_fullscreen
        var idx = $PanelContainer/MarginContainer/HBoxContainer/ViewMenuButton.get_popup().get_item_index(id)
        $PanelContainer/MarginContainer/HBoxContainer/ViewMenuButton.get_popup().set_item_checked(idx, OS.window_fullscreen)
    elif id == VIEW_STATS:
        var s = StatsWindow.instance()
        get_parent().add_child(s)
