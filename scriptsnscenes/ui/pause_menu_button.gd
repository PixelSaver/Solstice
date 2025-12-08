extends Button
class_name PauseMenuButton

var t : Tween
@export_range(0.1, 10., 0.1, "or_greater") var duration : float = 1.
@export var hover_col : Color = Color.AQUAMARINE
@export var idle_col : Color = Color.WHITE
var pause_menu : PauseMenu

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	self.pivot_offset = self.size/2.
	pause_menu = get_tree().get_first_node_in_group("pause_menu")
	t = create_tween()
	t.kill()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			t = _init_tween(t)
			t.tween_property(self, "scale", Vector2.ONE * 1.1, duration)
			t.tween_property(self, "modulate", hover_col, duration)
		NOTIFICATION_MOUSE_EXIT:
			t = _init_tween(t)
			t.tween_property(self, "scale", Vector2.ONE, duration)
			t.tween_property(self, "modulate", idle_col, duration)
		NOTIFICATION_FOCUS_ENTER:
			pass
		NOTIFICATION_FOCUS_EXIT:
			pass

func _init_tween(tween:Tween):
	if not tween: pass
	elif not tween.is_valid(): tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.set_parallel(true)
	return tween

func _on_pressed() -> void:
	pause_menu.menu_button_pressed.emit(self)
