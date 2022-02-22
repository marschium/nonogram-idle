extends Control

var bonus = null

func _set_text():
    $Control/Panel/Label.text = "%s\n%ds left" % [bonus.text, bonus.remaining()]

func _ready():
    if bonus != null:
        bonus.connect("deactivated", self, "_on_Bonus_deactivated")
        $MarginContainer/VBoxContainer/ProgressBar.value = 0
        $MarginContainer/VBoxContainer/ProgressBar.max_value = bonus.time
        $MarginContainer/VBoxContainer/TextureRect.texture = load("res://images/bonuses/%s.png" % [bonus.bonus_name.to_lower()])
    

func _process(delta):
    if bonus != null:
        $MarginContainer/VBoxContainer/ProgressBar.value = bonus.elapsed()
        self._set_text()

func _on_Bonus_deactivated():
    queue_free()


func _on_BonusLabel_mouse_entered():
    if not $Control/Panel.visible:
        self._set_text()
        $Control/Panel.visible = true


func _on_BonusLabel_mouse_exited():
    $Control/Panel.visible = false
