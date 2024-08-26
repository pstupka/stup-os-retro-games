extends Node

const SCREEN_SIZE: Vector2i = Vector2i(320, 240)

var game_started: float = false


func request_start_game() -> void:
	if not game_started:
		game_started = true
		Events.game_started.emit()
