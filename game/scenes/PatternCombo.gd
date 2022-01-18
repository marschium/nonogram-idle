extends Node2D

signal combo_complete(name)

var unmatched = ["cloud", "snowflake"]


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func add(pattern):
    unmatched.erase(pattern.pattern_name)
    if unmatched.empty():
        print_debug("matched pattern combo")
        emit_signal("combo_complete", "winter")
        unmatched = ["cloud", "snowflake"]

