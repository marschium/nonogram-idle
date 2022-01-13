extends Node2D

signal bonus_active(bonus)
signal bonus_inactive(name)

var active_bonuses = []



class Bonus:
    var name = ""
    var text = ""
    var timer = null
    var elapsed = 0
    
    func _init(n, t, timer):
        name = n
        text = t
        self.timer = timer
        self.timer.connect("timeout", self , "_on_Timer_timeout")
        
    func _on_Timer_timeout():
        print_debug("bepp")

# Called when the node enters the scene tree for the first time.
func _ready():
    PatternCombo.connect("combo_complete", self, "_on_PatternCombo_combo_complete")
    pass # Replace with function body.
    
func get_bonus(pattern):
    var bonus = 0
    for tag in pattern.tags:
        if active_bonuses.has(tag):
            bonus += pattern.num_tiles * 2
    return bonus

func _on_PatternCombo_combo_complete(name):
    if not active_bonuses.has(name):
        var bonus = Bonus.new(name, "example3", get_tree().create_timer(5.0))
        active_bonuses.append(bonus.name)
        emit_signal("bonus_active", bonus)
