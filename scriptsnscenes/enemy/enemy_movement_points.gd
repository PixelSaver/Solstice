extends Node3D
class_name EnemyMovementPoints

var points_list : Array[Marker3D]

func _ready() -> void:
	for child in get_children():
		if child is Marker3D:
			points_list.append(child)
	Global.enemy_movement_points = self
