extends Node2D

const UpgradeInfo = preload("res://scenes/UpgradeInfo.gd")

signal expand_grid_upgrade(new_size, cost, control)
signal autoclicker_upgrade(new_speed, cost, control)
signal color_upgrade(color, cost, control)
signal pattern_upgrade(control)

var UpgradeBuyControl = preload("res://scenes/ui/UpgradeBuyControl.tscn")

export(NodePath) var upgrades_np = null
var upgrades = upgrades_np
var revealed = false

onready var container = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
    $DraggableWindow.set_title("Upgrades")
    upgrades = get_node(upgrades_np)
    for upgrade in upgrades.get_children():
        upgrade.connect("available", self, "_on_UpgradeInfo_available", [upgrade])
        upgrade.connect("active", self, "_on_UpgradeInfo_active", [upgrade])
    
func reveal():
    if not revealed:
        revealed = true
        visible = true
        $AnimationPlayer.play("FadeIn")
        
func _on_UpgradeInfo_available(upgrade):
    reveal()
    var x = UpgradeBuyControl.instance()
    x.title = upgrade.desc
    x.cost = upgrade.cost
    x.set_meta("upgrade_tag", upgrade.tag)
    x.set_meta("upgrade_tag_v", upgrade.val)
    container.add_child(x)
    x.connect("selected", upgrade, "buy")
    
func _on_UpgradeInfo_active(upgrade):    
    remove_buy_button(upgrade.tag, upgrade.val)
    
func remove_buy_button(tag, v):
    for b in container.get_children():
        if b.get_meta("upgrade_tag") == tag and b.get_meta("upgrade_tag_v") == v:
            container.remove_child(b)
            b.queue_free()
    $DraggableWindow.repack()

func _on_ExpandGridButton_pressed(new_size):
    upgrades.buy_expand_upgrade(new_size)

func _on_AutoclickerButton_pressed(new_speed):
    upgrades.buy_autoclicker_upgrade(new_speed)
    
func _on_PatternButton_pressed(pack_id):
    upgrades.buy_patterns_upgrade(pack_id)

func remove_expand_board(size):
    remove_buy_button(UpgradeInfo.UpgradeTag.EXPAND, size)

func remove_autoclicker_speed(speed):
    remove_buy_button(UpgradeInfo.UpgradeTag.AUTOCLICK, speed)
    
func remove_patterns_active(pack_id):
    remove_buy_button(UpgradeInfo.UpgradeTag.PATTERN, pack_id)
