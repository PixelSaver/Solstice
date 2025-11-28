extends Node
class_name HealthComponent

signal died
signal health_changed(new_health:float)

@export var health : float = 10.
@export var max_health : float = 10.

func damage(attack:Attack):
	health = max(health-attack.attack_damage, 0)
	health_changed.emit(health)
	if health == 0:
		died.emit()
	print("damaged, health is %s" % health)

func heal(amount:float):
	health = min(health+amount, max_health)
	health_changed.emit(health)
