extends Node2D

signal clicked()
signal changed(was_changed_before)

var base_color = Color(0.1, 0.1, 0.1, 0.5)
var previous_color = null
var current_color = null
var x :int = 0
var y :int = 0

var anchor = Vector2(500, 500)

var just_clicked = false
var changed = false
var mouse_over = false
var modulate_track_idx = -1

onready var sprite = $Sprite
onready var sprite_pop = $SpritePop

func reset():
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
		sprite.modulate = color
		changed = true
		emit_signal("changed", already_changed)
		pop()
	
func click():
	if not just_clicked:
		just_clicked = true
		emit_signal("clicked")
		
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
	#$SpritePop/AnimationPlayer.play("TilePop")

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
func _process(delta):    
	if not just_clicked and mouse_over and Input.is_mouse_button_pressed(BUTTON_LEFT):
		click()
	if just_clicked and not Input.is_mouse_button_pressed(BUTTON_LEFT):
		just_clicked = false

func _on_Area2D_mouse_entered():
	mouse_over = true  #!Input.is_mouse_button_pressed(BUTTON_LEFT) # ignore mouse being held down

func _on_Area2D_mouse_exited():
	mouse_over = false
