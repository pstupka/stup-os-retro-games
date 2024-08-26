extends Area2D
class_name Player


signal lives_changed(lives: int)
signal died()
signal score_changed()

const MAX_VELOCITY: float = 300

@onready var body: Sprite2D = $SpritePivot/Body
@onready var eyes: AnimatedSprite2D = $SpritePivot/Eyes
@onready var antenna_l: Sprite2D = $SpritePivot/AntennaL
@onready var antenna_r: Sprite2D = $SpritePivot/AntennaR
@onready var leg_l: Sprite2D = $SpritePivot/LegL
@onready var leg_r: Sprite2D = $SpritePivot/LegR
@onready var eyes_blink_timer: Timer = $EyesBlinkTimer

@export var controls: PlayerControls = preload("res://utils/p0_controls.tres")
@export var jump_velocity: float = 250.0
@export var player_gravity: float = 500.0

var score = 0.0
var velocity: float = 0.0
var time_tick: float = 0

var _prev_position: float = 0.0


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	_prev_position = position.y

	eyes_blink_timer.timeout.connect(_on_blink_timer_timeout)


func _physics_process(delta: float) -> void:
	if not GameController.game_started:
		time_tick += delta
		position.y += sin(10 * time_tick)
		animation_sprite(_prev_position - position.y, false)
		_prev_position = position.y
		return

	velocity += player_gravity * delta

	if Input.is_action_just_pressed(controls.jump):
		print(controls.jump + " pressed")
		velocity -= jump_velocity

	velocity = clamp(velocity, -MAX_VELOCITY * 0.7, MAX_VELOCITY)
	position.y += velocity * delta
	animation_sprite(_prev_position - position.y)
	_prev_position = position.y


func animation_sprite(position_delta: float, animate_eyes: bool = true) -> void:
	leg_l.rotation_degrees = clamp(position_delta * 35, 0, 35)
	leg_r.rotation_degrees = clamp(position_delta * 35, 0, 35)
	antenna_l.rotation_degrees = clamp(-position_delta * 20, -20, 0)
	antenna_r.rotation_degrees = clamp(position_delta * 20, 0, 20)
	if animate_eyes:
		eyes.position.y = clamp(-position_delta * 2, -2, 0) - 4


func add_score(score_to_add: int) -> void:
	score += score_to_add
	score_changed.emit(score)


func die() -> void:
	print(str(self) + " died")
	died.emit()
	set_physics_process(false)
	$CollisionShape2D.call_deferred("set_disabled", true)
	eyes_blink_timer.stop()
	eyes.play("dead")
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position:y", 300, 5.0).set_delay(1)
	#queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Score"):
		add_score(1)
		print(str(self) + ": Score = " + str(score))
		return

	if area.is_in_group("Obstacles"):
		die()


func _on_blink_timer_timeout() -> void:
	eyes.play("blink")
	eyes_blink_timer.start(randf_range(1.5, 6.0))
