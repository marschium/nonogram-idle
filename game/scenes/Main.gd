extends Node2D

export var current_color = Color(1, 1, 1)
export var enable_autoclicker = false

var PatternUnlockControl = preload("res://scenes/ui/PatternUnlockControl.tscn")
var ComboUnlockControl = preload("res://scenes/ui/ComboUnlockControl.tscn")

onready var autoclicker = $Autoclicker
onready var upgrade_control = $UpgradeControl
onready var color_control = $ColorMenu

var save_file = "user://save.json"
var loaded = false
var popup_offset = Vector2(64, 64)
var popup_offset_delta = Vector2(8, 8)

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
    Patterns.savegame(d)
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
    Patterns.loadgame(d)

func toggle_autoclicker(enabled):
    autoclicker.set_process(enabled)
    autoclicker.stop()
    if enabled:
        if not autoclicker.has_clicker() and autoclicker.shuffle:
            autoclicker.add_pattern(Patterns.unlocked[randi() % Patterns.unlocked.size()])
        autoclicker.start()
        

# Called when the node enters the scene tree for the first time.
func _ready():
    TagCombo.connect("combo_complete", self, "_on_Combo_complete")
    PatternCombo.connect("unlocked", self, "_on_PatternCombo_unlocked")
    toggle_autoclicker(enable_autoclicker) # TODO remove
    for p in Patterns.get_children():
        $PatternsControl.add_pattern(p)
        p.connect("matched", self, "_on_Pattern_matched", [p])
        p.connect("unlocked", self, "_on_Pattern_unlocked", [p])
    $ColorMenu.set_palette(null, [Color(1, 1, 1)])
    
    for upgrade in $Upgrades.get_children():
        if upgrade.tag == "expand":
            upgrade.connect("active", self, "_on_Upgrade_expand_board", [upgrade.val])
        if upgrade.tag == "auto":            
            upgrade.connect("active", self, "_on_Upgrade_autoclicker_speed", [upgrade.val])
        if upgrade.tag == "pattern":
            upgrade.connect("active", self, "_on_Upgrade_pattern", [upgrade.val])

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
    for p in Patterns.get_children():
        p.reset()
        
    Score.add(pattern.num_tiles)
    TagCombo.add(pattern)
    PatternCombo.add(pattern)
    Score.add(Bonus.get_bonus(pattern))

    Patterns.reset_matches()
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
    p.position = popup_offset
    p.pattern = pattern
    p.connect("tree_exiting", self, "_on_UnlockControl_queue_free")
    add_child(p)
    popup_offset += popup_offset_delta
    
func _process(delta):
    if not loaded:        
        loadgame(save_file)
        loaded = true
        $AutosaveTimer.start()

func _on_Upgrade_expand_board(size):	
    $Gameboard.reset_board(size)	
    if size == 10: # TODO set this when pattern active		
        for p in Patterns.get_children():
            $Gameboard.connect("tile_changed", p, "_on_Gameboard_tile_changed")
            $Gameboard.connect("tile_reset", p, "_on_Gameboard_tile_reset")

func _on_Upgrade_autoclicker_speed(speed):
    $Autoclicker.set_speed(speed)
    $AutoclickerControl.reveal()
    $PatternsControl.enable_autoclick()
    
func _on_Upgrade_pattern(pack_id):
    Patterns.activate(pack_id)    
    $PatternsControl.reveal()

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
        

func _on_Autoclicker_cycle_finished():    
    if autoclicker.shuffle:
        autoclicker.clear(false)
        autoclicker.add_pattern(Patterns.unlocked[randi() % Patterns.unlocked.size()])


func _on_PatternsControl_pattern_selected(pattern):	
    autoclicker.add_pattern(pattern)


func _on_PatternCombo_unlocked(combo):	
    if not loaded:
        return
    var p = ComboUnlockControl.instance()
    p.position = popup_offset
    p.combo = combo
    p.connect("tree_exiting", self, "_on_UnlockControl_queue_free")
    add_child(p)
    popup_offset += popup_offset_delta


func _on_Gameboard_complete_late():
    # After fullsize and patterns, Gameboard is only cleared when pattern is matched
    if not Patterns.active:     
        Score.add($Gameboard.size * $Gameboard.size)   
        $Gameboard.reset()


func _on_ColorMenu_cleared():
    $ColorMenu.set_palette(null, [Color(1, 1, 1)])
    $Gameboard.hide_guide()


func _on_AutoclickerControl_loop_toggled(enabled):
    autoclicker.loop = enabled


func _on_AutoclickerControl_pattern_clicker_removed(clicker):
    autoclicker.remove_pattern_clicker(clicker)


func _on_AutoclickerControl_play():
    if autoclicker.can_run():
        var d = $Gameboard.next_unchanged()
        autoclicker.start(d.x, d.y)
        

func _on_AutoclickerControl_stop():
    toggle_autoclicker(false)


func _on_PatternsControl_guide_selected(pattern):
    var n = "?????"
    if pattern.unlocked:
        n = pattern.pattern_name
    $ColorMenu.set_palette(n, pattern.palette())
    $Gameboard.show_guide(pattern)

func _on_UnlockControl_queue_free():
    popup_offset -= popup_offset_delta


func _on_AutoclickerControl_shuffle_toggled(enabled):
    autoclicker.shuffle = enabled
    if enabled and not autoclicker.has_clicker():        
        autoclicker.add_pattern(Patterns.unlocked[randi() % Patterns.unlocked.size()])
