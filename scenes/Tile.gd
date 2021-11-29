extends Node2D

signal clicked()

var base_color = Color(1, 0, 0)

var just_clicked = false
var changed = false
var mouse_over = false

onready var sprite = $Sprite

func reset():
    sprite.modulate = base_color
    changed = false
    
func change(color):
    sprite.modulate = color
    changed = true

# Called when the node enters the scene tree for the first time.
func _ready():
    reset()
    
func _process(delta):    
    if not just_clicked and not changed and mouse_over and Input.is_mouse_button_pressed(BUTTON_LEFT):
        just_clicked = true
        emit_signal("clicked")
    if just_clicked and not Input.is_mouse_button_pressed(BUTTON_LEFT):
        just_clicked = false

func _on_Area2D_mouse_entered():
    mouse_over = !Input.is_mouse_button_pressed(BUTTON_LEFT) # ignore mouse being held down

func _on_Area2D_mouse_exited():
    mouse_over = false
