extends Node


@onready var split_line: Line2D = $SplitLine
@onready var players: Dictionary = {
	"1": {
		viewport_container = $HBoxContainer/SubViewportContainer,
		viewport = $HBoxContainer/SubViewportContainer/SubViewport,
		camera = $HBoxContainer/SubViewportContainer/SubViewport/Camera2D,
		player = $HBoxContainer/SubViewportContainer/SubViewport/Level/Player,
		level = $HBoxContainer/SubViewportContainer/SubViewport/Level,
		start_button = $PlayerStartButtons/ButtonSpriteP1
	},
	"2": {
		viewport_container = $HBoxContainer/SubViewportContainer2,
		viewport = $HBoxContainer/SubViewportContainer2/SubViewport,
		camera = $HBoxContainer/SubViewportContainer2/SubViewport/Camera2D,
		player = $HBoxContainer/SubViewportContainer2/SubViewport/Level/Player,
		level = $HBoxContainer/SubViewportContainer2/SubViewport/Level,
		start_button = $PlayerStartButtons/ButtonSpriteP2
	}
}
@onready var primary_level: Level = $HBoxContainer/SubViewportContainer/SubViewport/Level
@onready var player_start_buttons: Node2D = $PlayerStartButtons
@onready var restart_button: Button = $RestartButton

@export var single_player: bool = true


func _ready() -> void:
	if single_player:
		players["2"].viewport_container.queue_free()
		players["2"].start_button.queue_free()
		split_line.queue_free()

		players["1"].viewport.size = GameController.SCREEN_SIZE
		players["1"].camera.offset = GameController.SCREEN_SIZE/2
		players["1"].camera.initial_offset = players["1"].camera.offset
		players["1"].player.global_position.x += GameController.SCREEN_SIZE.x/4
		players["1"].start_button.global_position.x += GameController.SCREEN_SIZE.x/4
	else:
		players["2"].player.score_changed.connect(players["2"].level._on_player_score_changed)
		players["2"].player.died.connect(_on_player_died)

	players["1"].player.score_changed.connect(players["1"].level._on_player_score_changed)
	players["1"].player.died.connect(_on_player_died)

	restart_button.pressed.connect(_on_restart_button_pressed)


func _input(event: InputEvent) -> void:
	if not GameController.game_started and (event.is_action_pressed("p0_jump") or event.is_action_pressed("p1_jump")):
		GameController.request_start_game()
		player_start_buttons.queue_free()


func _on_restart_button_pressed() -> void:
	GameController.game_started = false
	get_tree().reload_current_scene()


func _on_player_died() -> void:
	if players["1"].player.dead and not single_player:
		players["2"].level.is_primary = true

	for player in players.values():
		if is_instance_valid(player.player) and not player.player.dead:
			return

	restart_button.show()
	restart_button.grab_focus()
