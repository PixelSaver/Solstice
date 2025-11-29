extends Control
class_name UI

@export var time_label : RichTextLabel
var start_time : float 
var counting := false

func _ready() -> void:
	start()

func start():
	start_time = Time.get_unix_time_from_system()
	counting = true

func _get_time_survived() -> float:
	return Time.get_unix_time_from_system() - start_time

func _process(_delta: float) -> void:
	if not counting: return
	time_label.text = "Time survived: %s" % _get_time_survived()
