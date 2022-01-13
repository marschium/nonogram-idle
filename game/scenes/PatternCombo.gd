extends Node2D

signal combo_complete(bonus)

class Bonus:
	var name = ""
	var text = ""
	var timer = null
	var elapsed = 0
	
	func _init(n, t):
		name = n
		text = t
		
	func activate():
		timer = Timer.new()
		timer.connect("elapsed", self, "_on_Timer_elapsed")
		timer.start()
		
	func _on_Timer_elapsed():
		print_debug("bepp")

var unmatched = ["cloud", "snowflake"]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add(pattern):
	unmatched.erase(pattern.pattern_name)
	if unmatched.empty():
		print_debug("matched pattern combo")
		var b = Bonus.new("winter", "example2")
		emit_signal("combo_complete", b)
		unmatched = ["cloud", "snowflake"]

