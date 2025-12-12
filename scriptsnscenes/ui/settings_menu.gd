extends Control
class_name SettingsMenu

func _input(_event: InputEvent) -> void:
	if Global.game_state != Global.State.SETTINGS: 
		self.hide()
	if Input.is_action_just_pressed("exit"):
		Global.game_state = Global.prev_game_state
