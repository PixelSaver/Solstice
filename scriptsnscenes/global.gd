extends Node

var player : Player

var enemy_man : EnemyManager
var enemy_movement_points : EnemyMovementPoints

signal death

enum State {
	MENU,
	SETTINGS,
	DIALOGUE,
	SURVIVE,
	WIN,
	DEAD,
}
signal state_changed
var game_state : State = State.MENU : 
	set(val):
		if game_state != val:
			game_state = val
			state_changed.emit()
			print("New Game State: %s" % game_state)
var game_paused := false :
	set(val):
		if game_paused != val:
			game_paused = val
			game_paused_changed.emit(val)
signal game_paused_changed(is_paused:bool)

var ui : UI 
