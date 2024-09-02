extends Node

const SCREEN_SIZE: Vector2i = Vector2i(320, 240)

var game_started: float = false
# Game options
var single_player: bool = true
var p1_color: Color = Color.WHITE
var p2_color: Color = Color.WHITE


func request_start_game() -> void:
	if not game_started:
		game_started = true
		Events.game_started.emit()
