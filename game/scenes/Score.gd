extends Node2D

signal changed(old, new)

var val = 0

func add(v):
    var old = val
    val += v 
    emit_signal("changed", old, val)
    
func sub(v):
    var old = val
    val -= v 
    emit_signal("changed", old, val)
