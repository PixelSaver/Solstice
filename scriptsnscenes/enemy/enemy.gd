extends RigidBody3D
class_name Enemy

var health_component : HealthComponent
var movement_points : EnemyMovementPoints
var move_idx : int = 0
var points : Array[Marker3D]
var current_target_position : Vector3

func _ready() -> void:
	health_component = get_tree().get_first_node_in_group("health_component") 
	health_component.died.connect(_on_death)
	#DEBUG
	await get_tree().create_timer(1).timeout
	move_to_next_point()
	await get_tree().create_timer(1).timeout
	move_to_next_point()
	await get_tree().create_timer(1).timeout
	move_to_next_point()

func set_movement_points(given_movement_points:EnemyMovementPoints):
	movement_points = given_movement_points
	points = given_movement_points.points_list
	_update_pos()

func move_to_next_point():
	move_idx += 1
	_update_pos()

func _update_pos():
	if move_idx < points.size():
		self.global_position = points[move_idx].global_position
	elif move_idx >= points.size():
		var t = create_tween().set_ease(Tween.EASE_IN)
		#t.tween_property(self, "global_position", Global.player.global_position, 4)
		#await get_tree().create_timer(3).timeout
		#Global.death.emit()

func _process(_delta: float) -> void:
	if not Global.player: return
	self.look_at(Global.player.global_position)

func _on_death():
	queue_free()
