extends Control


const GAME: PackedScene = preload("res://game.tscn")
@onready var player_number_button: FlappyMenuButton = %PlayerNumberButton
@onready var select_p_1_button: FlappyMenuButton = %SelectP1Button
@onready var select_p_2_button: FlappyMenuButton = %SelectP2Button
@onready var play: FlappyMenuButton = %Play
@onready var exit: FlappyMenuButton = %Exit

@onready var menu_move: AudioStreamPlayer = $Sfx/MenuMove
@onready var menu_select: AudioStreamPlayer = $Sfx/MenuSelect
@onready var menu_hint: Label = %MenuHint


var current_button: FlappyMenuButton


func _ready() -> void:
	current_button = player_number_button
	player_number_button.grab_focus()
	connect_signals()

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
				set_process_input(false)
				menu_select.play()
				play.animate_push()
				await menu_select.finished
				get_tree().change_scene_to_packed(GAME)
			exit.name:
				set_process_input(false)
				exit.animate_push()
				GameController.quit()


func _on_button_focused(button: FlappyMenuButton) -> void:
	current_button = button
	menu_hint.text = current_button.menu_hint
	menu_move.play()


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
