extends Node3D
class_name EnemyManager

const ENEMY_SCENE = preload("uid://obq4st7yapyq")
var enemy_list : Array[Enemy] = []

func _ready() -> void:
	Global.enemy_man = self
	enemy_spawn_loop()

func enemy_spawn_loop():
	print("spawned")
	inst_enemy()
	await get_tree().create_timer(5 + randf_range(-2,2)).timeout
	enemy_spawn_loop()

func inst_enemy():
	var enemy = ENEMY_SCENE.instantiate() as Enemy
	add_child(enemy)
	enemy_list.append(enemy)
	enemy.set_movement_points(Global.enemy_movement_points)
