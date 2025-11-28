extends Node3D
class_name EnemyManager

const ENEMY_SCENE = preload("uid://obq4st7yapyq")
var enemy_list : Array[Enemy] = []

func _ready() -> void:
	Global.enemy_man = self
	inst_enemy()

func inst_enemy():
	var enemy = ENEMY_SCENE.instantiate() as Enemy
	add_child(enemy)
	enemy_list.append(enemy)
	enemy.set_movement_points(Global.enemy_movement_points)
