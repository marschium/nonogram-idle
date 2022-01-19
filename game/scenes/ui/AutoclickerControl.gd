extends PanelContainer

signal pattern_clicker_removed(clicker)
signal play()
signal stop()

var ActivePatternControl = preload("res://scenes/ui/ActivePatternControl.tscn")

onready var active_pattern_container = $VBoxContainer/ActivePatternVBoxContainer

export var AutoclickerNode : NodePath = ""
var autoclicker = null

# Called when the node enters the scene tree for the first time.
func _ready():
	autoclicker = get_node(AutoclickerNode)
	autoclicker.connect("pattern_clicker_added", self, "_on_Autoclicker_pattern_clicker_added")
	autoclicker.connect("pattern_clicker_changed", self, "_on_Autoclicker_pattern_clicker_changed")
	autoclicker.connect("pattern_clicker_removed", self, "_on_Autoclicker_pattern_clicker_removed")
	autoclicker.connect("started", self, "_on_Autoclicker_started")
	autoclicker.connect("stopped", self, "_on_Autoclicker_stopped")
	update_counter()

	
func autoclicker_stopped():
	$VBoxContainer/HBoxContainer/PauseButton.pressed = true
	
func update_counter():
	$VBoxContainer/CountLabel.text = "%s/%s" % [autoclicker.clicker_count(), autoclicker.max_clickers]
	

func _on_Autoclicker_pattern_clicker_added(clicker):
	var b = ActivePatternControl.instance()
	b.clicker = clicker
	b.connect("removed", self, "_on_ActivePatternControl_removed", [clicker])
	active_pattern_container.add_child(b)
	update_counter()
	
func _on_Autoclicker_pattern_clicker_removed(clicker):
	for c in active_pattern_container.get_children():
		if c.clicker == clicker:
			c.queue_free()
	update_counter()
	
func _on_Autoclicker_pattern_clicker_changed(clicker):
	for c in active_pattern_container.get_children():
		if c.clicker == clicker:
			c.mark_active()
		else:
			c.mark_inactive()
			
func reveal():
	visible = true
	$AnimationPlayer.play("FadeIn")

func _on_Autoclicker_started():
	$VBoxContainer/HBoxContainer/PlayButton.pressed = true
	
func _on_Autoclicker_stopped():
	$VBoxContainer/HBoxContainer/PauseButton.pressed = true

func _on_ActivePatternControl_removed(pattern):
	emit_signal("pattern_clicker_removed", pattern)

func _on_PauseButton_pressed():
	emit_signal("stop")

func _on_PlayButton_pressed():
	emit_signal("play")
