extends Control
class_name PauseMenu

signal menu_button_pressed(button:Button)
signal anim_out_finished

func anim_in():
	show()
	
func anim_out():
	hide()
	anim_out_finished.emit()


func _on_menu_button_pressed(but:Button) -> void:
	var button_name = but.name.to_lower()
	match button_name:
		"resume":
			print("Play")
			Global.game_state = Global.State.SURVIVE
			self.hide()
		"settings":
			print("settings")
			Global.game_state = Global.State.SETTINGS
		"quit":
			print("quit")
			get_tree().reload_current_scene()
		_:
			return
