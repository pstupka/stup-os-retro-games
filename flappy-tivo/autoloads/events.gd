extends Node

signal loading_finished
signal loading_started

signal add_shake_trauma(amount: float)
signal player_score_changed(id: int, score: int)

signal obstacle_spawn_request(offset: float)

signal game_started()

signal menu_button_option_changed(button: FlappyMenuButton, menu_option: MenuOption)
