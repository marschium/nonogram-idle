extends MarginContainer

var bonus = null
var mouse_over = false
var state = null

onready var label = $Node2D/PanelContainer/Label


func idle(dt):
    if mouse_over:    
        label.text = bonus.text
        $Node2D.visible = true
        state = funcref(self, "hovering")


func hovering(dt):
    if not mouse_over:      
        label.text = ""
        $Node2D.visible = false
        state = funcref(self, "idle")
    else:
        $Node2D.global_position = get_global_mouse_position() - Vector2(0, 16) 


# Called when the node enters the scene tree for the first time.
func _ready():
    state = funcref(self, "idle")
    bonus.connect("unlocked", self, "_on_Bonus_unlocked")
    if bonus.unlocked:
        $PanelContainer/TextureRect.texture = load("res://images/bonuses/%s.png" % [bonus.id])
    else:
        $PanelContainer/TextureRect.texture = load("res://images/bonuses/unknown.png")


func _process(delta):    
    self.state.call_func(delta)

func _on_Bonus_unlocked():
    $PanelContainer/TextureRect.texture = load("res://images/bonuses/%s.png" % [bonus.id])    


func _on_TextureRect_mouse_entered():
    mouse_over = bonus.unlocked


func _on_TextureRect_mouse_exited():
    mouse_over = false
