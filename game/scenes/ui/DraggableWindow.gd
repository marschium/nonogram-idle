extends Node2D

export var show_close = false

var state = null
var mouse_over_bar = false
var mouse_offset = Vector2.ZERO
var maximised = true
var previous_size = Vector2(0, 0)

onready var title_bar = $MarginContainer/MarginContainer/VBoxContainer/PanelContainer


func idle(dt):
    if mouse_over_bar and Input.is_mouse_button_pressed(BUTTON_LEFT):
        mouse_offset = get_global_mouse_position() - global_position
        state = funcref(self, "dragging")

func dragging(dt):
    if mouse_over_bar and Input.is_mouse_button_pressed(BUTTON_LEFT):
        global_position = get_global_mouse_position() - mouse_offset
    else:
        state = funcref(self, "idle")


# Called when the node enters the scene tree for the first time.
func _ready():
    previous_size = $MarginContainer.rect_size
    state = funcref(self, "idle")
    $MarginContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CloseButton.visible = show_close
    minimise()
    maximise()
    
func maximise():
    $MarginContainer/MarginContainer/VBoxContainer/CenterContainer.visible = true
    maximised = true
    $MarginContainer.rect_size.x = previous_size.x

func minimise():
    previous_size = $MarginContainer.rect_size
    $MarginContainer/MarginContainer/VBoxContainer/CenterContainer.visible = false
    $MarginContainer.rect_size = Vector2($MarginContainer.rect_size.x, title_bar.rect_size.y) + Vector2(0, 8)
    maximised = false
    
func enable_close():
    show_close = true
    $MarginContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CloseButton.visible = show_close
    
    
func set_title(t):
    $MarginContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/Label.text = t

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    self.state.call_func(delta)


func _on_Label_mouse_entered():
    mouse_over_bar = !Input.is_mouse_button_pressed(BUTTON_LEFT) # ignore mouse being held down


func _on_Label_mouse_exited():
    mouse_over_bar = false

func _on_Button_pressed():
    if maximised:
        minimise()
    else:
        maximise()


func _on_CloseButton_pressed():
    queue_free()
