extends Node2D

signal bonus_active(bonus)
signal bonus_inactive(name)

var ActiveBonus = preload("res://scenes/ActiveBonus.tscn")

var active_bonuses = {}

# Called when the node enters the scene tree for the first time.
func _ready():
    PatternCombo.connect("combo_complete", self, "_on_PatternCombo_combo_complete")
    
func get_bonus(pattern):
    var bonus = 0
    for k in active_bonuses.keys():
        bonus += active_bonuses.get(k).effect.get_pattern_bonus(pattern)
    return bonus

func _on_PatternCombo_combo_complete(combo):
    if not active_bonuses.has(combo.name):
        var bonus = ActiveBonus.instance()
        bonus.bonus_name = combo.name
        bonus.text = combo.desc
        bonus.time = combo.duration
        bonus.connect("deactivated", self, "_on_Bonus_deactivated", [bonus])
        add_child(bonus)
        active_bonuses[combo.name] = combo
        emit_signal("bonus_active", bonus)

func _on_Bonus_deactivated(bonus):
    active_bonuses.erase(bonus.name)
