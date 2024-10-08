extends Node
class_name Level

const OBSTACLE = preload("res://entities/obstacle.tscn")
const OBSTACLE_MAX_INSTANCES: int = 10
const INITIAL_OBSTACLE_POSITIONS: Array[int] = [-41, -35, -124, -72, -30]
const PLAYER: PackedScene = preload("res://entities/player.tscn")
const BG_TEXTURES: Array[Texture] = [
	preload("res://assets/sprites/bg_hbbtv.png"),
	preload("res://assets/sprites/bg_radio_1.png"),
	preload("res://assets/sprites/bg_radio_2.png"),
]


@onready var obstacle_bounds: Area2D = $ObstacleBounds
@onready var score_label: Label = $GUI/MarginContainer/ScoreLabel
@onready var background: Sprite2D = $Background

@export var obstacle_speed: float = 20.0
@export var obstacle_separation: int = 200
@export var is_primary: bool = true
var obstacles: Array = []
var player: Player = null


func _ready() -> void:
	Events.obstacle_spawn_request.connect(_on_obstacle_spawn_requested)
	Events.game_started.connect(_on_game_started, ConnectFlags.CONNECT_ONE_SHOT)
	obstacle_bounds.area_entered.connect(_on_obstacle_bounds_area_entered)

	if not get_node_or_null("Player"):
		player = PLAYER.instantiate()
		player.global_position = Vector2(20, 120)
		add_child(player)
	else:
		player = $Player
	player.died.connect(_on_player_died)
	background.texture = BG_TEXTURES.pick_random()


func spawn_obstacle(offset: float) -> void:
	var obstacle: Area2D = OBSTACLE.instantiate()
	if obstacles.is_empty():
		obstacle.global_position.x = 350
	else:
		obstacle.global_position.x = obstacles.back().global_position.x + obstacle_separation

	obstacle.global_position.y = offset
	call_deferred("add_child", obstacle)
	obstacles.push_back(obstacle)

	if obstacles.size() > OBSTACLE_MAX_INSTANCES:
		obstacles.pop_front().queue_free()


func _process(delta: float) -> void:
	for obstacle in obstacles:
		obstacle.position.x -= obstacle_speed * delta


func _on_obstacle_spawn_requested(offset: float) -> void:
	spawn_obstacle(offset)


func _on_obstacle_bounds_area_entered(area: Area2D) -> void:
	if not area.is_in_group("Obstacles") and not is_primary:
		return
	Events.obstacle_spawn_request.emit(randi_range(-135, 5))


func _on_player_score_changed(score: int) -> void:
	score_label.text = str(score)
	score_label.pivot_offset = score_label.size / 2
	var tween: Tween = score_label.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(score_label, "scale", Vector2.ONE, 0.3).from(Vector2(1.4,1.4))


func _on_game_started() -> void:
	for pos in INITIAL_OBSTACLE_POSITIONS:
		spawn_obstacle(pos)


func _on_player_died() -> void:
	set_process(false)
	Events.obstacle_spawn_request.disconnect(_on_obstacle_spawn_requested)
	obstacle_bounds.area_entered.disconnect(_on_obstacle_bounds_area_entered)
