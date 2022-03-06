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
    
func add_active_bonus(bonus):
    if not active_bonuses.has(bonus.bonus_name):
        bonus.connect("deactivated", self, "_on_Bonus_deactivated", [bonus])
        add_child(bonus)
        active_bonuses[bonus.bonus_name] = bonus
        emit_signal("bonus_active", bonus)
        

func _on_PatternCombo_combo_complete(combo):
    if not active_bonuses.has(combo.name):
        var bonus = ActiveBonus.instance()
        bonus.bonus_name = combo.name
        bonus.id = combo.bonus_id
        bonus.text = combo.desc
        bonus.time = combo.duration
        bonus.effect = combo.effect
        add_active_bonus(bonus)

func _on_Bonus_deactivated(bonus):
    var a = active_bonuses.get(bonus.bonus_name)
    active_bonuses.erase(bonus.bonus_name)
    remove_child(bonus)
    bonus.queue_free()
