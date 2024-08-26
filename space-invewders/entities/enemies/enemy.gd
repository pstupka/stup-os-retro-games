extends Area2D

const BULLET = preload("res://entities/bullets/enemy_bullet.tscn")
@onready var shoot_timer: Timer = $ShootTimer
@onready var pivot: Node2D = $Pivot
@onready var sprite: Sprite2D = $Pivot/Sprite
@export var score: int = 10
@export var health: float = 1.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	shoot_timer.wait_time = randf_range(5.0, 10.0)
	shoot_timer.start()


func take_damage(from: Player, damage: float) -> void:
	Events.add_shake_trauma.emit(0.2)
	from.add_score(score)

	health -= damage * from.get_damage_multiplier()
	if health <= 0.0:
		destroy()


func destroy() -> void:
	$GPUParticles2D.emitting = true
	sprite.hide()
	await get_tree().create_timer($GPUParticles2D.lifetime).timeout
	queue_free()


func shoot() -> void:
	shoot_timer.start(randf_range(5.0, 10.0))
	var bullet: EnemyBullet = BULLET.instantiate()
	var tween: Tween = create_tween()
	bullet.global_position = global_position + Vector2(0, 8)
	bullet.direction = Vector2.DOWN
	bullet.speed = 100
	get_tree().root.add_child(bullet)

	tween.tween_property(pivot, "scale", Vector2(0.8, 1.4), 0.1)
	tween.tween_property(pivot, "scale", Vector2.ONE, 0.15)


func _on_shoot_timer_timeout() -> void:
	shoot()


func _on_area_entered(area: PlayerBullet) -> void:
	if not area:
		return

	take_damage(area.player, area.damage)
	area.take_damage()
