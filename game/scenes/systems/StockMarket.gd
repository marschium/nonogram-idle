extends Node2D

export var update_interval = 1.0
export var x_step = 50
export var zero_offset = 500
export var base_price = 100

var timer = 0.0
var noise = OpenSimplexNoise.new()
var noise_pos = Vector2(0,0)
var noise_dir = Vector2(randf(), randf()).normalized()
var noise_speed = 1

var y_pos_multipler = 5
var current_owned = 0

onready var draw_area = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Control
onready var line = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Control/Line2D
onready var label = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/CurrentPriceLabel
onready var owned_label = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/HBoxContainer/CurrentOwnedLabel


func get_current_price():
    return base_price + int(base_price * noise.get_noise_2dv(noise_pos))

# Called when the node enters the scene tree for the first time.
func _ready():
    $DraggableWindow.set_title("Stock Market")
    Bonus.connect("bonus_active", self, "_on_Bonus_bonus_active")
    
    noise.seed = randi()
    noise.octaves = 8
    noise.period = 20.0
    noise.persistence = 0.6
    noise.lacunarity = 1.5
    
    zero_offset = draw_area.rect_position.y + (draw_area.rect_size.y / 2)
    y_pos_multipler = draw_area.rect_size.y / (base_price * 2) # need to show +- 100 points
    var num_steps = draw_area.rect_size.x / x_step
    for i in range(num_steps):
        var d = base_price - get_current_price()
        line.add_point(Vector2(i * x_step, zero_offset + (d * y_pos_multipler)))
        
    owned_label.text = str(current_owned)
    
func _on_Bonus_bonus_active(bonus):
    if bonus.id == "stock_market":
        visible = true
        bonus.connect("deactivated", self, "_on_ActiveBonus_deactivated")
        
func _on_ActiveBonus_deactivated():
    # TODO disconnect from bonus?
    visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    timer += delta
    if timer >= update_interval:
        noise_pos += (noise_dir * noise_speed)
        timer = 0.0
        label.text = "%d" % get_current_price()
        # shift everything to the left
        for p in range(line.get_point_count()):
            var v = line.get_point_position(p)
            line.set_point_position(p, Vector2(v.x - x_step, v.y))
        line.remove_point(0)
        var d = base_price - get_current_price()
        line.add_point(Vector2(line.get_point_count() * x_step, zero_offset + (d * y_pos_multipler)))

func _buy(x):
    if Score.val > get_current_price() * x:
        Score.sub(get_current_price() * x)
        current_owned += x
        owned_label.text = str(current_owned)
   
     
func _sell(x):
    if current_owned >= x:
        Score.add(get_current_price() * x)
        current_owned -= x
        owned_label.text = str(current_owned)


func _on_BuyButton_pressed():
    _buy(1)


func _on_SellButton_pressed():
    _sell(1)


func _on_10BuyButton_pressed():
    _buy(10)


func _on_SellAllButton_pressed():
    _sell(10)
