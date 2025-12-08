extends Control
class_name UI

@export var time_label : RichTextLabel
@export var hud : Control
@export var death_screen : Control
@export var pause_screen : PauseMenu
@export var settings_screen : Control
@export var start_screen : MainMenu
var start_time : float 
var counting := false

func _ready() -> void:
	get_tree().paused = true
	death_screen.hide()
	Global.ui = self
	Global.state_changed.connect(_on_state_changed)
	Global.game_paused_changed.connect(_on_pause)
	
func _on_state_changed():
	match Global.game_state:
		Global.State.SURVIVE:
			get_tree().paused = false
			start_counter()
		Global.State.DEAD:
			get_tree().paused = true
			death_screen.show()
		Global.State.SETTINGS:
			get_tree().paused = true
			settings_screen.show()

func _on_pause(is_paused:bool):
	if is_paused:
		pause_screen.show()
		get_tree().paused = true
	else:
		pause_screen.hide()
		get_tree().paused = false

func start_counter():
	start_time = Time.get_unix_time_from_system()
	counting = true

func _get_time_survived() -> float:
	return Time.get_unix_time_from_system() - start_time

func _process(_delta: float) -> void:
	if not counting: return
	time_label.text = "Time survived: %s" % _get_time_survived()
	if Input.is_action_just_pressed("pause"):
		Global.game_paused = true
