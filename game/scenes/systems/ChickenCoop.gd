extends Node2D

var ActiveBonus = preload("res://scenes/ActiveBonus.tscn")

export var update_interval = 5.0
export var production_chance = 0.8
export var num_food = 0
export var num_chickens = 0
export var num_eggs = 0

var timer = 0.0
onready var food_label = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/FoodLabel
onready var chicken_label = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ChickenLabel
onready var egg_label = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/EggLabel
onready var update_bar = $DraggableWindow/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ProgressBar

func ln(arg : float) -> float:
    return log(arg)/log(exp(1))

func normal(avg : float = 0.0, sd : float = 1.0) -> float:
    return avg+sd*sqrt(-2*(ln(randf())))*cos(2*PI*randf())

# Called when the node enters the scene tree for the first time.
func _ready():
    Bonus.connect("bonus_active", self, "_on_Bonus_bonus_active")
    for p in Patterns.get_children():
        if p.pattern_name == "orange":
            p.connect("matched", self, "_on_FoodPattern_matched")
        if p.pattern_name == "red":
            p.connect("matched", self, "_on_ChickenPattern_matched")
    _update_ui()
            
func _on_Bonus_bonus_active(bonus):
    if bonus.id == "chicken_coop":
        visible = true
        bonus.connect("deactivated", self, "_on_ActiveBonus_deactivated")
        
func _on_ActiveBonus_deactivated():
    # TODO disconnect from bonus?
    visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if not visible:
        return
    timer += delta
    if timer >= update_interval:
        # each update there is a chance that each chicken will consume one
        # food and produce one egg
        timer = 0.0
        if num_chickens > 0 and num_food > 0:
            var eggs_created = int(normal(min(num_chickens, num_food) * production_chance, 1.0))
            eggs_created = max(0, min(eggs_created, num_food))
            num_eggs += eggs_created
            num_food -= eggs_created
        _update_ui()    
    update_bar.value = timer / update_interval
            
func _update_ui():
    food_label.text = "Food: %d" % num_food
    chicken_label.text = "Chickens: %d" % num_chickens
    egg_label.text = "Eggs: %d" % num_eggs

func _on_FoodPattern_matched(bonus):
    num_food += 5
    _update_ui()


func _on_ChickenPattern_matched(bonus):
    num_chickens += 5
    _update_ui()


func _on_Button_pressed():
    if num_eggs > 0:
        Score.add(num_eggs * 10)
        num_eggs = 0
        _update_ui()
        # TODO calculate the multiple effect and duration from number of eggs
        var bonus = ActiveBonus.instance()
        bonus.bonus_name = "Egg"
        bonus.id = "Egg"
        bonus.text = "% bonus for eggs"
        bonus.time = 60
        # TODO effect
        Bonus.add_active_bonus(bonus)
        queue_free()
