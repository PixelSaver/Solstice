extends Node
class_name HealthComponent

signal died
signal health_changed(new_health:float)

@export var health : float = 10.
@export var max_health : float = 10.

func damage(amount:float):
	health = max(health-amount, 0)
	health_changed.emit(health)

func heal(amount:float):
	health = min(health+amount, max_health)
	health_changed.emit(health)
