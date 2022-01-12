extends Control


func _on_PanelContainer_mouse_entered():
	if not $Label.visible:
		$Label.visible = true


func _on_PanelContainer_mouse_exited():
	$Label.visible = false
