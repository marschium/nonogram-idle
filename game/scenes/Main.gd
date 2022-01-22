extends Node2D

export var current_color = Color(1, 1, 1)
export var enable_autoclicker = false

var PatternUnlockControl = preload("res://scenes/ui/PatternUnlockControl.tscn")
var ComboUnlockControl = preload("res://scenes/ui/ComboUnlockControl.tscn")

onready var autoclicker = $Autoclicker
onready var upgrade_control = $CanvasLayer/UpgradeControl
onready var game_control = $CanvasLayer/GameControl
onready var color_control = $CanvasLayer/ColorMenu

var save_file = "user://save.json"
var loaded = false

func read_json_file(file_path):
    var file = File.new()
    file.open(file_path, File.READ)
    var content_as_text = file.get_as_text()
    var content_as_dictionary = parse_json(content_as_text)
    return content_as_dictionary
    
func savegame(filepath):
    var d = {}
    d["score"] = Score.val
    $Upgrades.savegame(d)
    $Patterns.savegame(d)
    PatternCombo.savegame(d)
    
    var file = File.new()
    file.open(filepath, File.WRITE)
    file.store_line(to_json(d))
    file.close()
    
    
func loadgame(filepath):
    var d = read_json_file(filepath)
    if d == null:
        return
    Score.add(d.get("score", 0))
    PatternCombo.loadgame(d)
    $Upgrades.loadgame(d)
    $Patterns.loadgame(d)

func toggle_autoclicker(enabled):
    autoclicker.set_process(enabled)
    autoclicker.stop()
    if enabled:
        autoclicker.start()
        

# Called when the node enters the scene tree for the first time.
func _ready():
    TagCombo.connect("combo_complete", self, "_on_Combo_complete")
    PatternCombo.connect("unlocked", self, "_on_PatternCombo_unlocked")
    toggle_autoclicker(enable_autoclicker) # TODO remove
    for p in $Patterns.get_children():
        $CanvasLayer/GameControl.add_pattern(p)
        p.connect("matched", self, "_on_Pattern_matched", [p])
        p.connect("unlocked", self, "_on_Pattern_unlocked", [p])
    $Gameboard.pop_anchor = $CanvasLayer/ScoreControl.rect_global_position + ($CanvasLayer/ScoreControl.rect_size / 2)

func _on_Autoclicker_click(x, y, color):
    $Gameboard.change_dot(x, y, color)    

func _on_Autoclicker_click_any(color):
    $Gameboard.next_unchanged().change(current_color)

func _on_Gameboard_tile_clicked(tile):
    autoclicker.stop()
    tile.change(current_color)
    
func _on_Gameboard_tile_right_clicked(tile):
    autoclicker.stop()
    tile.clear()

func _on_Pattern_matched(bonus, pattern):
    # TODO should this be done in the _process?
    var was_autoclicked = autoclicker.running
    autoclicker.pause()
    
    # TODO pattern checking can be quicker
    for p in $Patterns.get_children():
        p.reset()
        
    Score.add(pattern.num_tiles)
    TagCombo.add(pattern)
    PatternCombo.add(pattern)			
    Score.add(Bonus.get_bonus(pattern))

    #yield(get_tree().create_timer(0.2), "timeout")

    $Patterns.reset_matches()
    $Gameboard.reset()
    TagCombo.tick()
    
    if was_autoclicked:	
        autoclicker.next_clicker()
    if autoclicker.running:
        autoclicker.resume()

func _on_Pattern_unlocked(pattern):
    if not loaded:
        return
    var p = PatternUnlockControl.instance()
    p.pattern = pattern
    $CanvasLayer.add_child(p)
    
func _process(delta):
    if not loaded:        
        $Upgrades.buy_color_upgrade(Color("#ffffff"))
        loadgame(save_file)
        loaded = true
        $AutosaveTimer.start()

func _on_Upgrades_expand_board_upgrade_active(size):	
    $Gameboard.reset_board(size)	
    if size == 16:		
        for p in $Patterns.get_children():
            $Gameboard.connect("tile_changed", p, "_on_Gameboard_tile_changed")
            $Gameboard.connect("tile_reset", p, "_on_Gameboard_tile_reset")

func _on_Upgrades_autoclicker_active(speed):
    $Autoclicker.set_speed(speed)
    $CanvasLayer/GameControl.enable_autoclick()
    
func _on_Upgrades_patterns_active():
    # TODO move to autoclicker control?
    $CanvasLayer/GameControl.enable_pattern_select()

func _on_ColorMenu_color_select(color):
    current_color = color

func _on_Combo_complete(words, num):
    print("Combo finished")
    if num <= 1:
        return
    Score.add(256 * num) # TODO score per keyword?

func _on_AutosaveTimer_timeout():
    print_debug("Saving")
    savegame(save_file)


func _on_GameControl_autoclick_toggled(enabled):	
    if enabled and autoclicker.can_run():
        var d = $Gameboard.next_unchanged()
        autoclicker.start(d.x, d.y)
    else:
        toggle_autoclicker(false)


func _on_GameControl_guide_toggled(enabled, pattern):
    if enabled:
        $Gameboard.show_guide(pattern)
    else:
        $Gameboard.hide_guide()
        

func _on_Autoclicker_cycle_finished():
    TagCombo.reset()
    PatternCombo.reset()


func _on_GameControl_pattern_clicker_toggled(enabled, clicker):
    autoclicker.remove_pattern_clicker(clicker)


func _on_GameControl_pattern_selected(pattern):	
    autoclicker.add_pattern(pattern)


func _on_PatternCombo_unlocked(combo):	
    if not loaded:
        return
    var p = ComboUnlockControl.instance()
    p.combo = combo
    $CanvasLayer.add_child(p)


func _on_Gameboard_complete_late():
    # After fullsize, Gameboard is only cleared when pattern is matched
    if $Gameboard.size < 16:        
        $Gameboard.reset()
