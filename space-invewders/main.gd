extends Node2D

@onready var player_0: Player = $Players/Player
@onready var player_1: Player = $Players/Player2
@onready var player_0_lives: PlayerLivesIndicator = %Player0Lives
@onready var player_1_lives: PlayerLivesIndicator = %Player1Lives
@onready var player_0_status: Label = %Player0Status
@onready var player_1_status: Label = %Player1Status
@onready var hi_score_label: Label = %HiScoreLabel
@onready var p_0_score_label: Label = $UI/TopMarginContainer/Player0ScoreContainer/P0ScoreLabel
@onready var p_1_score_label: Label = $UI/TopMarginContainer/Player1ScoreContainer/P1ScoreLabel
@onready var player_1_press_to_start: Label = $UI/BottomMarginContainer/Player1PressToStart
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var single_player: bool = true:
	set(new_player):
		single_player = new_player
		player_1.is_disabled = new_player
		player_1_lives.visible = not new_player
		if not new_player:
			player_1.make_immune(2.0)
			player_1_press_to_start.queue_free()

var is_game_over: bool = false

func _ready() -> void:
	single_player = GameController.game_mode == GameController.GAME_MODE.Single
	hi_score_label.text = "%012d" % Leaderboard.get_high_score()
	player_0_lives.init(player_0)
	player_1_lives.init(player_1)
	player_0.died.connect(_on_player_0_died)
	player_1.died.connect(_on_player_1_died)
	p_0_score_label.init(player_0)
	p_1_score_label.init(player_1)

	if single_player:
		Utils.blink_node(player_1_press_to_start)
	await animation_player.animation_finished
	start_game()


func start_game() -> void:
	player_0.make_immune(2.0)


func _input(event: InputEvent) -> void:
	if single_player and not is_game_over:
		if Input.is_action_pressed("p1_move_left") or \
			Input.is_action_pressed("p1_move_right") or \
			Input.is_action_pressed("p1_shoot"):
				single_player = false


func _on_player_0_died() -> void:
	player_0_status.text = "GAME OVER"
	Utils.blink_node(player_0_status)

	if player_1.is_disabled:
		game_over()


func _on_player_1_died() -> void:
	player_1_status.text = "GAME OVER"
	Utils.blink_node(player_1_status)

	if player_0.is_disabled:
		game_over()


func game_over() -> void:
	is_game_over = true

	if is_instance_valid(player_1_press_to_start):
		player_1_press_to_start.queue_free()

	var high_score = maxi(player_0.score, player_1.score)
	if high_score > 0 and Leaderboard.is_score_valid(high_score):
		Leaderboard.add_score("", high_score)
