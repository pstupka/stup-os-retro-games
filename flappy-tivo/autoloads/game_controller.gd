extends Node

enum {GAME_NOT_READY, GAME_READY, GAME_STARTED, GAME_PAUSED, GAME_STOPPED, GAME_FINISHED}

const SCREEN_SIZE: Vector2i = Vector2i(320, 240)

var game_state: int = GAME_NOT_READY
# Game options
var single_player: bool = true
var p1_color: Color = Color.WHITE
var p2_color: Color = Color.WHITE


func request_start_game() -> void:
	if game_state == GAME_READY:
		game_state = GAME_STARTED
		Events.game_started.emit()


func restart() -> void:
	game_state = GAME_NOT_READY
	get_tree().reload_current_scene()


func main_menu() -> void:
	game_state = GAME_NOT_READY
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")


func quit() -> void:
	get_tree().quit()
