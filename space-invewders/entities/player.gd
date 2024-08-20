extends Area2D
class_name Player


signal lives_changed(lives: int)
signal died()
signal score_changed()

const COLORIZE = preload("res://assets/shaders/colorize.gdshader")
const VEWD_V2: Texture = preload("res://assets/sprites/vewd_v2.png")
const BULLET: PackedScene = preload("res://entities/bullets/player_bullet.tscn")
const MAX_LIVES: int = 4

@export var is_disabled: bool = false:
	set(disabled):
		is_disabled = disabled
		visible = not disabled
		if collision:
			collision.set_deferred("disabled", disabled)


@export var move_speed: float = 200.0
@export_enum("Player 1", "Player 2") var id: int = 0
@onready var sprite: Sprite2D = $Sprite
@onready var collision: CollisionShape2D = $CollisionShape2D

var lives: int = 4:
	set(new_lives):
		lives = new_lives
		lives_changed.emit(lives)
var immune_time: float = 1.0
var is_immune: bool = false
var score: int = 0

var _can_move: bool = true


func _ready() -> void:
	lives = min(lives, MAX_LIVES)
	if id == 1:
		sprite.texture = VEWD_V2
	area_entered.connect(_on_area_entered)
	is_disabled = is_disabled
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = COLORIZE
	sprite.material.set_shader_parameter("color", GameController.COLOR_TIVO_BLUE)


func _physics_process(delta: float) -> void:
	if is_disabled: return

	if not _can_move:
		move(0, delta)
		return

	var direction: int = get_direction()
	if Input.is_action_just_pressed("p%d_shoot" % id): shoot()

	move(direction, delta)


func get_direction() -> int:
	return int(Input.get_axis("p%d_move_left" % id, "p%d_move_right" % id))


func move(direction: int, delta: float) -> void:
	var rotation_weight: float = 0.2

	if direction:
		position.x += direction * move_speed * delta
		rotation_weight = 0.4

	sprite.rotation_degrees = lerpf(sprite.rotation_degrees, direction * 10, rotation_weight )


func shoot() -> void:
	var tween: Tween = self.create_tween()
	tween.tween_property(sprite, "scale", Vector2(0.8, 1.3), 0.05)
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.1)
	var bullet: Bullet = BULLET.instantiate()
	bullet.global_position = global_position + Vector2(0, -10)
	bullet.player = self
	get_tree().root.add_child(bullet)


func take_damage() -> void:
	if is_immune:
		return

	Events.add_shake_trauma.emit(0.3)
	lives -= 1
	if lives == 0:
		die()
		return

	knockback()
	immobilize_after_damage(0.5, immune_time)


func die() -> void:
	died.emit()
	is_disabled = true


func make_immune(time: float) -> void:
	is_immune = true
	var tween: Tween = create_tween()
	tween.tween_callback(sprite.set_visible.bind(false)).set_delay(time/6)
	tween.tween_callback(sprite.set_visible.bind(true)).set_delay(time/6)
	tween.tween_callback(sprite.set_visible.bind(false)).set_delay(time/6)
	tween.tween_callback(sprite.set_visible.bind(true)).set_delay(time/6)
	tween.tween_callback(sprite.set_visible.bind(false)).set_delay(time/6)
	tween.tween_callback(sprite.set_visible.bind(true)).set_delay(time/6)
	await tween.finished
	is_immune = false


func immobilize_after_damage(immobilize_time: float, immunity_time: float = 0.0) -> void:
	_can_move = false
	is_immune = true
	var tween: Tween = create_tween().set_loops(4)
	tween.tween_method(set_hurt_intensity, 0.0, 1.0, immobilize_time/8)
	tween.tween_method(set_hurt_intensity, 1.0, 0.0, immobilize_time/8)
	await tween.finished
	sprite.material.set_shader_parameter("enabled", false)
	_can_move = true
	if immunity_time > 0:
		make_immune(immunity_time)


func set_hurt_intensity(value: float) -> void:
	sprite.material.set_shader_parameter("mix_intensity", value)


func knockback() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "position:y", 5, 0.05)
	tween.tween_property(sprite, "position:y", 0, 0.1)


func add_score(score_to_add: int) -> void:
	score += score_to_add
	score_changed.emit(score)


func _on_area_entered(bullet: EnemyBullet) -> void:
	if not bullet or bullet.dealt_damage:
		return

	take_damage()
	bullet.take_damage()
