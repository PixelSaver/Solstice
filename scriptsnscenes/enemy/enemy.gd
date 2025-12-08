extends StaticBody3D
class_name Enemy

signal reached_point(idx:int)
@export var move_speed : float = 2.
@export var anim_player : AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
var movement_points : EnemyMovementPoints
var move_idx : int = 0
var points : Array[Marker3D]
var current_target_position : Vector3
var is_moving := false

func _ready() -> void:
	health_component.died.connect(_on_death)
	reached_point.connect(_on_point_reached)

func set_movement_points(given_movement_points : EnemyMovementPoints):
	movement_points = given_movement_points
	points = given_movement_points.points_list
	_begin_movement()

func _begin_movement():
	self.global_position = points[move_idx].global_position
	move_to_next_point()

func move_to_next_point():
	move_idx += 1
	_update_pos()

func _update_pos():
	if move_idx < points.size():
		current_target_position = points[move_idx].global_position
	#elif move_idx >= points.size():
		## End of movement points
		#var t = create_tween().set_ease(Tween.EASE_IN)
		#t.tween_property(self, "global_position", Global.player.global_position, 4)
		#await get_tree().create_timer(3).timeout
		#Global.death.emit()

func _on_point_reached(idx:int):
	print("idx: %s" % idx)
	if idx < points.size()-1:
		await get_tree().create_timer(randfn(1, 2)).timeout
		move_to_next_point()
	elif idx == points.size()-1:
		anim_player.speed_scale = 1.
		anim_player.play("idle")
		self.look_at(Global.player.global_position)
		anim_player.animation_finished.connect(
			func(_anim_name:String):
				anim_player.play("walk")
				current_target_position = Global.player.global_position
				move_to_next_point()
				move_speed *= 5
				, CONNECT_ONE_SHOT
			)
	else:
		Global.game_state = Global.State.DEAD

func _process(delta: float) -> void:
	if not Global.player or Global.game_state != Global.State.SURVIVE: return
	is_moving = false if current_target_position.is_equal_approx(self.global_position) else true
	if is_moving and anim_player.current_animation == "walk":
		self.look_at(current_target_position)
		self.global_position = self.global_position.move_toward(current_target_position, delta * move_speed)
		anim_player.speed_scale = 1.
		if current_target_position.is_equal_approx(\
			self.global_position):
			is_moving = false
			reached_point.emit(move_idx)
	elif anim_player.current_animation == "walk":
		anim_player.speed_scale = 0.
		self.look_at(Global.player.global_position)

func _on_death():
	queue_free()
