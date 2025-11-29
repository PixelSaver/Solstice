extends Camera3D

@export var raycast : RayCast3D
@export var gun_marker : Marker3D
@export var gun : MeshInstance3D
const SPARKS = preload("uid://b7lor67ljfeg8")

var player : Player

func _ready() -> void:
	player = get_parent() as Player
	if not player: queue_free()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("l_click"): 
		if raycast.is_colliding(): 
			_on_hit()
		pass
	if Input.is_action_just_pressed("r_click"): 
		pass
		
func _on_hit():
	if not raycast.is_colliding(): return
	player._damage(raycast.get_collider())
	var inst = SPARKS.instantiate() as CPUParticles3D
	inst.global_position = raycast.get_collision_point()
	inst.emitting = true
	var normal = raycast.get_collision_normal()
	inst.look_at(inst.global_position + normal, Vector3.UP)
	get_tree().current_scene.add_child(inst)


func _process(_delta: float) -> void:
	if raycast.is_colliding():
		gun_marker.look_at(raycast.get_collision_point(), Vector3.UP, false)
