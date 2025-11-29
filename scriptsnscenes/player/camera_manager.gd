extends Node3D
class_name CameraManager

var player_cam : Camera3D
var cam_areas : Array

func _ready() -> void:
	player_cam = get_viewport().get_camera_3d()
	cam_areas = get_tree().get_nodes_in_group("camera_area") 
	if cam_areas.size() == 0: 
		print("Bruh no camera areas found in camera_manager")
		return
	#Global.player.
	for area in cam_areas:
		if area is not AreaBodyEnter: 
			cam_areas.erase(area)
			continue
		area.body_entered_custom.connect(_on_area_entered_custom)

func _on_area_entered_custom(body:Node3D, area:Area3D):
	if body is not Player: return
	print("Body entered: %s" % body.name)
	match area.name.to_lower():
		"left":
			print("left hit")
		"right":
			print("right hit")
	
