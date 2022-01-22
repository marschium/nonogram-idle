extends Node2D

signal clicked()
signal right_clicked()
signal changed(was_changed_before)
signal reset()

var base_color = Color(0.1, 0.1, 0.1, 0.5)
var previous_color = null
var current_color = null
var swap_color = null
var x :int = 0
var y :int = 0

var anchor = Vector2(500, 500)

var just_clicked = false
var changed = false
var mouse_over = false
var modulate_track_idx = -1
var shrinking = false

onready var sprite = $Sprite
onready var sprite_pop = $SpritePop

func swapto(color):
    swap_color = color
    shrinking = true
    $Tween.interpolate_property(
        self, 
        "scale", 
        Vector2(1, 1), 
        Vector2(0, 0), 
        0.1, 
        Tween.TRANS_LINEAR, 
        Tween.EASE_IN_OUT)
    $Tween.start()

func reset():
    if changed:
        swapto(base_color)
    previous_color = null
    current_color = null
    sprite.modulate = base_color
    sprite_pop.modulate = Color(1, 1, 1, 0.0)
    changed = false
    
func change(color):
    if color != current_color:
        var already_changed = changed
        previous_color = current_color
        current_color = color
        changed = true
        swapto(current_color)
        
func clear():
    previous_color = current_color
    current_color = null
    sprite.modulate = base_color
    emit_signal("reset")
    changed = false
    #pop()
    
func click():
    if not just_clicked:
        just_clicked = true
        emit_signal("clicked")
        
func right_click():
    if not just_clicked:
        just_clicked = true
        emit_signal("right_clicked")
        
func pop():
    var target_color = sprite.modulate
    target_color.a = 0
    var tween = $SpritePop/Tween
    tween.interpolate_property(
        $SpritePop, 
        "position", 
        Vector2(0, 0), 
        to_local(anchor), 
        1, 
        Tween.TRANS_LINEAR, 
        Tween.EASE_IN_OUT)
    tween.interpolate_property(
        $SpritePop, 
        "modulate", 
        sprite.modulate, 
        target_color, 
        1, 
        Tween.TRANS_LINEAR, 
        Tween.EASE_IN_OUT)
    $SpritePop/Tween.start()

# Called when the node enters the scene tree for the first time.
func _ready():
    reset()
    
func _process(delta):    
    if not just_clicked and mouse_over and Input.is_mouse_button_pressed(BUTTON_LEFT):
        click()
    elif not just_clicked and mouse_over and Input.is_mouse_button_pressed(BUTTON_RIGHT):
        right_click()

    if just_clicked and not Input.is_mouse_button_pressed(BUTTON_LEFT):
        just_clicked = false
    elif just_clicked and not not Input.is_mouse_button_pressed(BUTTON_RIGHT):
        just_clicked = false

func _on_Area2D_mouse_entered():
    mouse_over = true  #!Input.is_mouse_button_pressed(BUTTON_LEFT) # ignore mouse being held down

func _on_Area2D_mouse_exited():
    mouse_over = false

func _on_Tween_tween_all_completed():
    if shrinking:
        sprite.modulate = swap_color
        swap_color = null
        shrinking = false
        $Tween.interpolate_property(
            self, 
            "scale", 
            Vector2(0, 0), 
            Vector2(1, 1), 
            0.1, 
            Tween.TRANS_LINEAR, 
            Tween.EASE_IN_OUT)
        $Tween.start()
    else:
        emit_signal("changed", changed)
