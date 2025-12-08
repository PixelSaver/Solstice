extends Control
class_name PauseMenu

signal anim_out_finished

func anim_in():
	show()
	
func anim_out():
	hide()
	anim_out_finished.emit()
