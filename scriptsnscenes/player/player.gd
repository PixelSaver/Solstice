class_name Player 
extends CharacterBody3D

@export_group("Movement")
@export_range(1, 35, 1) var speed: float = 10 # m/s
@export_range(10, 400, 1) var acceleration: float = 100 # m/s^2

@export_range(0.1, 3.0, 0.1) var jump_height: float = 1 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var head_sens: float = 3.
var sense_mult : float = 1.
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@export_group("Shooting")
@export var damage : float = 1.0

var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2
var look_dir: Vector2

var walk_vel: Vector3 
var grav_vel: Vector3 
var jump_vel: Vector3

func _ready() -> void:
	Global.player = self
	capture_mouse()
	await get_tree().process_frame
	camera.make_current()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_head()
	if Input.is_action_just_pressed("jump"): jumping = true
	if Input.is_action_just_pressed("bruh"): release_mouse()
	if Input.is_action_just_pressed("exit"): get_tree().quit()

func _physics_process(delta: float) -> void:
	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_head(sens_mod: float = 1.0) -> void:
	head.rotation.y -= look_dir.x * head_sens * sens_mod
	head.rotation.x = clamp(head.rotation.x - look_dir.y * head_sens * sens_mod, -1.5, 1.5)

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var _forward: Vector3 = head.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel

func _damage(target:Node):
	var health_comp : HealthComponent
	for child in target.get_children():
		if child is HealthComponent:
			health_comp = child
			break
	if not health_comp: 
		print("No health comp found in Player.gd")
		return 
	health_comp.damage(Attack.new(damage))
	
