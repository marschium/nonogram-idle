extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
    Bonus.bonus_by_name("RGB").connect("activated", self, "_on_Bonus_bonus_active")
    Bonus.bonus_by_name("RGB").connect("deactivated", self, "_on_ActiveBonus_deactivated")


func _on_Bonus_bonus_active():
    visible = true

func _on_ActiveBonus_deactivated():
    visible = false
