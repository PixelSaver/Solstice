extends Area3D
class_name AreaBodyEnter

signal body_entered_custom(body:Node3D, area:Area3D)
var target_cam : Camera3D

func _ready():
	self.body_entered.connect(_on_body_entered)
	for child in get_children():
		if child is Camera3D:
			target_cam = child
			return
	print("Camera not found in area_body_enter")
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	body_entered_custom.emit(body, self)
