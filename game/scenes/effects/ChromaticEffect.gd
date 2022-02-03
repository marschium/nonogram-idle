extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
    Bonus.connect("bonus_active", self, "_on_Bonus_bonus_active")


func _on_Bonus_bonus_active(bonus):
    visible = true
