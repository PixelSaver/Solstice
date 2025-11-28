extends Camera3D

@export var raycast : RayCast3D
@export var gun_marker : Marker3D
@export var gun : MeshInstance3D
var player : Player

func _ready() -> void:
	player = get_parent() as Player
	if not player: queue_free()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("l_click"): 
		#player._damage()
		pass
	if Input.is_action_just_pressed("r_click"): 
		pass
func _process(_delta: float) -> void:
	if raycast.is_colliding():
		gun_marker.look_at(raycast.get_collision_point(), Vector3.UP, false)
