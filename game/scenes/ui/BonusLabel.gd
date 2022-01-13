extends Control

var bonus = null

func _on_PanelContainer_mouse_entered():
	if not $Panel.visible:
		$Panel/Label.text = bonus.text
		$Panel.visible = true


func _on_PanelContainer_mouse_exited():
	$Panel.visible = false
