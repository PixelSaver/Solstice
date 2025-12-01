extends Node3D
class_name CameraManager

var player_cam : Camera3D
var og_pos : Vector3
var og_fov : float
var target_cam : Camera3D = null
var cam_areas : Array
@export var speed_mult : float = 1.
@export var exit_speed_mult : float = 5.
@export var rot_margin : float = 1.

func _ready() -> void:
	await get_tree().process_frame
	player_cam = get_viewport().get_camera_3d()
	cam_areas = get_tree().get_nodes_in_group("camera_area") 
	if cam_areas.size() == 0: 
		print("Bruh no camera areas found in camera_manager")
		return
	og_pos = player_cam.position
	og_fov = player_cam.fov
	for area in cam_areas:
		if area is not AreaBodyEnter: 
			cam_areas.erase(area)
			continue
		area.body_entered_custom.connect(_on_area_entered_custom)
		area.body_exited.connect(_on_body_exited)

func _on_area_entered_custom(body:Node3D, _area:Area3D):
	if body is not Player: return
	if _area is not AreaBodyEnter: return
	var area = _area as AreaBodyEnter
	match area.name.to_lower():
		"left":
			target_cam = area.target_cam
		"right":
			target_cam = area.target_cam

func _on_body_exited(_body:Node3D):
	target_cam = null

func _process(delta: float) -> void:
	if target_cam: 
		player_cam.top_level = true
		player_cam.global_position = lerp(player_cam.global_position, target_cam.global_position, delta * speed_mult)
		player_cam.fov = lerp(player_cam.fov, target_cam.fov, delta * speed_mult)
		player_cam.global_rotation.y = clampf(
			player_cam.global_rotation.y, 
			target_cam.global_rotation.y - rot_margin, target_cam.global_rotation.y + rot_margin
			)
	else: 
		player_cam.top_level = false
		player_cam.position = lerp(player_cam.position, og_pos, delta * speed_mult)
		player_cam.fov = lerp(player_cam.fov, og_fov, delta * exit_speed_mult)
