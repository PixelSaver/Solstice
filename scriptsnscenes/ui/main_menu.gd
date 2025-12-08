extends Control
class_name MainMenu

signal menu_button_pressed(button_name:String)
signal anim_out_finished

func anim_in():
	show()

func anim_out():
	hide()
	anim_out_finished.emit()


func _on_menu_button_pressed(button_name: String) -> void:
	button_name = button_name.to_lower()
	match button_name:
		"play":
			print("Play")
			Global.menu_to_play_game.emit()
			Global.ui.start_game()
		"settings":
			print("settings")
			Global.ui.settings_screen.show()
		"quit":
			print("quit")
			get_tree().reload_current_scene()
		_:
			return
		
