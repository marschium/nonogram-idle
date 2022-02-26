extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
    Bonus.connect("bonus_active", self, "_on_Bonus_bonus_active")


func _on_Bonus_bonus_active(bonus):
    if bonus.bonus_name == "RGB":
        visible = true
        bonus.connect("deactivated", self, "_on_ActiveBonus_deactivated")

func _on_ActiveBonus_deactivated():
    # TODO disconnect from bonus?
    visible = false
