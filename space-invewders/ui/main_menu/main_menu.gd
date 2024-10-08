extends Control

const MAIN: PackedScene = preload("res://main.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_single_player: Button = $MarginContainer/VBoxContainer/StartSinglePlayer
@onready var start_multiplayer: Button = $MarginContainer/VBoxContainer/StartMultiplayer
@onready var exit_button: Button = $MarginContainer/VBoxContainer/ExitButton
@onready var settings_button: Button = $MarginContainer/VBoxContainer/SettingsButton


func _ready() -> void:
	animation_player.play("intro")
	start_single_player.pressed.connect(_on_menu_button_pressed.bind(start_single_player), ConnectFlags.CONNECT_ONE_SHOT)
	start_multiplayer.pressed.connect(_on_menu_button_pressed.bind(start_multiplayer), ConnectFlags.CONNECT_ONE_SHOT)
	exit_button.pressed.connect(_on_menu_button_pressed.bind(exit_button))
	settings_button.pressed.connect(_on_menu_button_pressed.bind(settings_button))
	start_single_player.grab_focus()
	print(ProjectSettings.globalize_path("user://"))


func _input(event: InputEvent) -> void:
	if event.is_action_type() and animation_player.current_animation == "intro" and animation_player.is_playing():
		animation_player.play("RESET")


func _on_menu_button_pressed(button: Button) -> void:
	if button.name == exit_button.name:
		get_tree().quit()
		return

	if button.name == settings_button.name:
		print("Settings button pressed")
		return

	if button.name == start_single_player.name:
		GameController.game_mode = GameController.GAME_MODE.Single
	if button.name == start_multiplayer.name:
		GameController.game_mode = GameController.GAME_MODE.Multi

	animation_player.play("start_game_transition")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(MAIN)
