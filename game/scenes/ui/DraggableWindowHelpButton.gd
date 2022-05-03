extends Button

var helptext = ""
var state = null
var mouse_over = false

func idle(dt):
    if mouse_over:    
        $HelpPopup/PanelContainer/Label.text = helptext
        $HelpPopup.visible = true
        state = funcref(self, "hovering")


func hovering(dt):
    if not mouse_over:      
        $HelpPopup/PanelContainer/Label.text = ""
        $HelpPopup.visible = false
        state = funcref(self, "idle")
    else:
        $HelpPopup.global_position = get_global_mouse_position() - Vector2(-16, 16) 


func _ready():
    state = funcref(self, "idle")


func _process(delta):    
    self.state.call_func(delta)


func _on_DraggableWindowHelpButton_mouse_entered():
    mouse_over = true


func _on_DraggableWindowHelpButton_mouse_exited():
    mouse_over = false
