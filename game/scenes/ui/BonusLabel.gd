extends Control

var bonus = null

func _ready():
	$ProgressBar.value = 0
	$ProgressBar.max_value = bonus.time
	

func _process(delta):
	if bonus != null:
		$ProgressBar.value = bonus.elapsed()

func _on_PanelContainer_mouse_entered():
	if not $Panel.visible:
		$Panel/Label.text = bonus.text
		$Panel.visible = true


func _on_PanelContainer_mouse_exited():
	$Panel.visible = false
