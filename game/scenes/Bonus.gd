extends Node2D

signal bonus_active(bonus)
signal bonus_inactive(name)

var ActiveBonus = preload("res://scenes/ActiveBonus.tscn")

var active_bonuses = {}

class Nothing:
    func get_pattern_bonus(pattern):
        return 0

class MultiplyTag:
    var val = 1
    var tag = ""
    
    func _init(val, tag):
        self.val = val
    
    func get_pattern_bonus(pattern):
        if pattern.tags.has(tag):
            return pattern.num_tiles * self.val

# Called when the node enters the scene tree for the first time.
func _ready():    
    var a = ActiveBonus.instance()
    a.bonus_name = "RGB"
    a.id = "RGB"
    a.effect = MultiplyTag.new(0.1, "color")
    a.text = "10% Bonus For Color Tags"
    a.time = 20
    a.connect("activated", self, "_on_Bonus_activated", [a])
    add_child(a)
    
    a = ActiveBonus.instance()
    a.bonus_name = "Chicken Coop"
    a.id = "chicken_coop"
    a.effect = Nothing.new()
    a.text = "Activates The Chicken Coop"
    a.time = 300
    a.connect("activated", self, "_on_Bonus_activated", [a])
    add_child(a)
    
    a = ActiveBonus.instance()
    a.bonus_name = "Stock Market"
    a.id = "stock_market"
    a.effect = Nothing.new()
    a.text = "Activates The Stock Market"
    a.time = 300
    a.connect("activated", self, "_on_Bonus_activated", [a])
    add_child(a)
    
func bonus_by_name(name):
    for c in get_children():
        if c.bonus_name == name:
            return c
    return null
    
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
    # TODO WIP    
    
    if not active_bonuses.has(combo.name):
        var bonus = ActiveBonus.instance()
        bonus.bonus_name = combo.name
        bonus.id = combo.bonus_id
        bonus.text = combo.desc
        bonus.time = combo.duration
        bonus.effect = combo.effect
        add_active_bonus(bonus)
        
func _on_Bonus_activated(bonus):
    emit_signal("bonus_active", bonus)

func _on_Bonus_deactivated(bonus):
    var a = active_bonuses.get(bonus.bonus_name)
    active_bonuses.erase(bonus.bonus_name)
    remove_child(bonus)
    bonus.queue_free()
