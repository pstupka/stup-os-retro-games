extends Control


const GAME: PackedScene = preload("res://game.tscn")
@onready var player_number_button: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/PlayerNumberButton
@onready var select_p_1_button: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/SelectP1Button
@onready var select_p_2_button: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/SelectP2Button
@onready var play: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/Play
@onready var exit: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/Exit

var current_button: FlappyMenuButton


func _ready() -> void:
	connect_signals()
	player_number_button.grab_focus()


func connect_signals() -> void:
	player_number_button.focus_entered.connect(_on_button_focused.bind(player_number_button))
	select_p_1_button.focus_entered.connect(_on_button_focused.bind(select_p_1_button))
	select_p_2_button.focus_entered.connect(_on_button_focused.bind(select_p_2_button))
	play.focus_entered.connect(_on_button_focused.bind(play))
	exit.focus_entered.connect(_on_button_focused.bind(exit))
	Events.menu_button_option_changed.connect(_menu_button_option_changed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		current_button.select_next()
	if event.is_action_pressed("ui_up"):
		current_button.select_previous()
	if event.is_action_pressed("ui_accept"):
		match current_button.name:
			play.name:
				get_tree().change_scene_to_packed(GAME)
			exit.name:
				GameController.quit()



func _on_button_focused(button: FlappyMenuButton) -> void:
	current_button = button


func _menu_button_option_changed(button: FlappyMenuButton, menu_option: MenuOption) -> void:
	match button.name:
		player_number_button.name:
			if menu_option.option_name == "P1":
				select_p_2_button.is_disabled = true
				GameController.single_player = true
			else:
				select_p_2_button.is_disabled = false
				GameController.single_player = false
			print("Is single player: %s" % GameController.single_player)
		select_p_1_button.name:
			GameController.p1_color = menu_option.modulate
		select_p_2_button.name:
			GameController.p2_color = menu_option.modulate
