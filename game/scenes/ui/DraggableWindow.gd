extends Node2D


var state = null
var mouse_over_bar = false
var mouse_offset = Vector2.ZERO


func idle(dt):
    #z_index = 0
    if mouse_over_bar and Input.is_mouse_button_pressed(BUTTON_LEFT):
        mouse_offset = get_global_mouse_position() - global_position
        state = funcref(self, "dragging")

func dragging(dt):
    #z_index = 1
    if mouse_over_bar and Input.is_mouse_button_pressed(BUTTON_LEFT):
        global_position = get_global_mouse_position() - mouse_offset
    else:
        state = funcref(self, "idle")


# Called when the node enters the scene tree for the first time.
func _ready():    
    state = funcref(self, "idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    self.state.call_func(delta)


func _on_Label_mouse_entered():
    mouse_over_bar = !Input.is_mouse_button_pressed(BUTTON_LEFT) # ignore mouse being held down


func _on_Label_mouse_exited():
    mouse_over_bar = false
