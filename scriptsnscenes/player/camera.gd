extends Camera3D

@export var raycast : RayCast3D
@export var gun_marker : Marker3D
@export var gun : MeshInstance3D

func _process(_delta: float) -> void:
	if raycast.is_colliding():
		gun_marker.look_at(raycast.get_collision_point())
