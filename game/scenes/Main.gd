extends Node2D

export var current_color = Color(1, 1, 1)
export var enable_autoclicker = false

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
    
    var file = File.new()
    file.open(filepath, File.WRITE)
    file.store_line(to_json(d))
    file.close()
    
    
func loadgame(filepath):
    var d = read_json_file(filepath)
    if d == null:
        return
    Score.add(d.get("score", 0)) # TODO might need to avoid generating signals
    $Upgrades.loadgame(d)
    $Patterns.loadgame(d)

func toggle_autoclicker(enabled):
    autoclicker.set_process(enabled)
    autoclicker.stop()
    if enabled:
        autoclicker.start()
    # autoclicker_button.visible = autoclicker.running
    if autoclicker.running:
        $CanvasLayer/GameControl.autoclicker_running()
    else:
        $CanvasLayer/GameControl.autoclicker_stopped()
        

# Called when the node enters the scene tree for the first time.
func _ready():
    # $CanvasLayer/UpgradeControl.upgrades = $Upgrades
    Combo.connect("combo_complete", self, "_on_Combo_complete")
    $CanvasLayer/GameControl.add_color(current_color)
    $CanvasLayer/ColorMenu.add_color(current_color)
    # TODO should the Patterns be responsible for multiplexing?
    toggle_autoclicker(enable_autoclicker) # TODO remove
    for p in $Patterns.get_children():
        $CanvasLayer/GameControl.add_pattern(p)
    $Gameboard.pop_anchor = $CanvasLayer/ScoreControl.rect_global_position + ($CanvasLayer/ScoreControl.rect_size / 2)

func _on_Autoclicker_click(x, y, color):
    # TODO this is a nightmare
    if $Gameboard.get_dot(x, y).changed:
        var t = $Gameboard.next_unchanged()
        autoclicker.set_pos(t.x, t.y)
        var v = autoclicker.get_current()
        $Gameboard.change_dot(t.x, t.y, v)    
    else:
        $Gameboard.change_dot(x, y, color)    

func _on_Autoclicker_click_any(color):
    $Gameboard.next_unchanged().change(current_color)

func _on_Gameboard_tile_clicked(tile):
    autoclicker.stop()
    $CanvasLayer/GameControl.autoclicker_stopped()
    tile.change(current_color)

var cleared = false
func _on_Gameboard_complete_late():
    cleared = true
    
func _process(delta):
    if not loaded:
        loaded = true
        loadgame(save_file)
        $AutosaveTimer.start()
    if cleared:
        var was_autoclicked = autoclicker.running
        autoclicker.stop()
        for p in $Patterns.get_matches():
            # Score.add(p.bonus)
            Combo.add(p)
        $Patterns.reset_matches()
        $Gameboard.reset()
        Combo.tick()
        #yield(get_tree().create_timer(0.2), "timeout")
        cleared = false
        if was_autoclicked:
            autoclicker.next_clicker()
            autoclicker.start(0, 0)

func _on_Upgrades_expand_board_upgrade_active(size):	
    $Gameboard.reset_board(size)	
    if size == 16:		
        for p in $Patterns.get_children():
            $Gameboard.connect("tile_changed", p, "_on_Gameboard_tile_changed")
            $Gameboard.connect("complete", p, "_on_Gameboard_complete")

func _on_Upgrades_autoclicker_active(speed):
    $Autoclicker.set_speed(speed)
    $CanvasLayer/GameControl.enable_autoclick()
    
func _on_Upgrades_patterns_active():
    # TODO move to autoclicker control?
    $CanvasLayer/GameControl.enable_pattern_select()

func _on_Upgrades_color_active(color):
    # TODO move to color control?
    $CanvasLayer/ColorMenu.add_color(color)
    $CanvasLayer/GameControl.add_color(color)

func _on_ColorMenu_color_select(color):
    current_color = color


func _on_Combo_complete(words, num):
    print("Combo finished")
    Score.add(256 * num) # TODO score per keyword?

func _on_Autoclicker_pattern_changed(pattern):
    game_control.autoclicker_current_pattern(pattern)

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


func _on_GameControl_pattern_toggled(enabled, pattern):
    if enabled:
        autoclicker.add_pattern(pattern)
    else:
        autoclicker.remove_pattern(pattern)
        if not autoclicker.running:
            toggle_autoclicker(false)
