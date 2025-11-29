extends Area3D
class_name AreaBodyEnter

signal body_entered_custom(body:Node3D, area:Area3D)

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	body_entered_custom.emit(body, self)
