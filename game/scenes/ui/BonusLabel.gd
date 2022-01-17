extends Control

var bonus = null

func _set_text():
	$Panel/Label.text = "%s\n%ds left" % [bonus.text, bonus.remaining()]

func _ready():
	bonus.connect("deactivated", self, "_on_Bonus_deactivated")
	$ProgressBar.value = 0
	$ProgressBar.max_value = bonus.time
	

func _process(delta):
	if bonus != null:
		$ProgressBar.value = bonus.elapsed()
		self._set_text()

func _on_PanelContainer_mouse_entered():
	if not $Panel.visible:
		self._set_text()
		$Panel.visible = true


func _on_PanelContainer_mouse_exited():
	$Panel.visible = false

func _on_Bonus_deactivated():
	queue_free()
