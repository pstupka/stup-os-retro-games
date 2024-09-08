extends Control
class_name PauseMenu


@onready var restart: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/Restart
@onready var main_menu: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/MainMenu
@onready var exit: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/Exit
@onready var menu_move: AudioStreamPlayer = $Sfx/MenuMove
@onready var menu_select: AudioStreamPlayer = $Sfx/MenuSelect

var current_button: FlappyMenuButton
var can_pick: bool = true


func _ready() -> void:
	restart.focus_entered.connect(_on_button_focused.bind(restart))
	main_menu.focus_entered.connect(_on_button_focused.bind(main_menu))
	exit.focus_entered.connect(_on_button_focused.bind(exit))

	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", 0, 0.6)
	tween.tween_callback(restart.grab_focus)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and current_button:
		match current_button.name:
			restart.name:
				set_process_input(false)
				menu_select.play()
				restart.animate_push()
				await menu_select.finished
				GameController.restart()
			main_menu.name:
				set_process_input(false)
				menu_select.play()
				main_menu.animate_push()
				await menu_select.finished
				GameController.main_menu()
			exit.name:
				set_process_input(false)
				exit.animate_push()
				menu_select.play()
				await menu_select.finished
				GameController.quit()


func _on_button_focused(button: FlappyMenuButton) -> void:
	current_button = button
	menu_move.play()
