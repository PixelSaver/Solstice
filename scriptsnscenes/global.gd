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
var game_state : State = State.MENU

var ui : UI 
signal menu_to_play_game
