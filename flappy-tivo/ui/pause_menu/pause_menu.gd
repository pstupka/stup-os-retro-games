extends Control
class_name PauseMenu


@onready var restart: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/Restart
@onready var main_menu: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/MainMenu
@onready var exit: FlappyMenuButton = $CenterContainer/MarginContainer/ButtonsContainer/Exit

var current_button: FlappyMenuButton


func _ready() -> void:
	restart.focus_entered.connect(_on_button_focused.bind(restart))
	main_menu.focus_entered.connect(_on_button_focused.bind(main_menu))
	exit.focus_entered.connect(_on_button_focused.bind(exit))
	restart.grab_focus()

	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", 0, 0.6)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		match current_button.name:
			restart.name:
				GameController.restart()
			main_menu.name:
				GameController.main_menu()
			exit.name:
				GameController.quit()


func _on_button_focused(button: FlappyMenuButton) -> void:
	current_button = button
