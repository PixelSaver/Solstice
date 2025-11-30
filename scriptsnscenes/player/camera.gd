extends Camera3D

@export var raycast : RayCast3D
@export var gun_marker : Marker3D
@export var gun : MeshInstance3D
var curr_dist : float = 100.
var target_dist : float = -1.
@export var MIN_TARGET_DIST : float = 1.5
@export var fov_z_offset : float = 0.013
var og_marker : Vector3
var is_aiming := false

var can_shoot := true

const SPARKS = preload("uid://b7lor67ljfeg8")

var player : Player

func _ready() -> void:
	player = get_parent() as Player
	og_marker = gun_marker.position
	if not player: queue_free()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("l_click"): 
		if raycast.is_colliding(): 
			_on_hit()
	if Input.is_action_just_pressed("r_click"): 
		is_aiming = true
	elif Input.is_action_just_released("r_click"):
		is_aiming = false
		
func _on_hit():
	if not raycast.is_colliding(): return
	player._damage(raycast.get_collider())
	var inst = SPARKS.instantiate() as CPUParticles3D
	get_tree().current_scene.add_child(inst)
	inst.global_position = raycast.get_collision_point()
	inst.emitting = true
	var normal = raycast.get_collision_normal()
	inst.look_at(inst.global_position + normal, Vector3.UP)


func _process(delta: float) -> void:
	if is_aiming:
		gun_marker.position.x *= .9
	else:
		gun_marker.position = lerp(gun_marker.position, og_marker, delta*3)
	gun_marker.position.z = og_marker.z + lerpf(0, fov_z_offset, 75-player.camera.fov)
	
	if raycast.is_colliding():
		target_dist = raycast.get_collision_point().distance_to(raycast.global_position)
	
	if not target_dist < 0:
		curr_dist = lerp(curr_dist, target_dist, delta * 10) 
		curr_dist = max(curr_dist, MIN_TARGET_DIST)
	
	gun_marker.look_at(
		raycast.global_position - raycast.global_basis.z * curr_dist,
		Vector3.UP, false
	)
