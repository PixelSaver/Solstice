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
	Global.death.connect(_on_death)
	death_screen.hide()
	Global.ui = self
	start_game()

func start_game():
	start_time = Time.get_unix_time_from_system()
	counting = true

func _get_time_survived() -> float:
	return Time.get_unix_time_from_system() - start_time

func _process(_delta: float) -> void:
	if not counting: return
	time_label.text = "Time survived: %s" % _get_time_survived()

func _on_death():
	get_tree().paused = true
	death_screen.show()
