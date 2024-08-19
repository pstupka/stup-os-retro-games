extends Area2D

const BULLET = preload("res://entities/bullets/enemy_bullet.tscn")
@onready var shoot_timer: Timer = $ShootTimer
@export var score: int = 10


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	shoot_timer.wait_time = randf_range(5.0, 10.0)
	shoot_timer.start()


func take_damage(from: Player) -> void:
	Events.add_shake_trauma.emit(0.2)
	from.add_score(score)
	queue_free()


func _on_shoot_timer_timeout() -> void:
	shoot_timer.start(randf_range(5.0, 10.0))
	var bullet: EnemyBullet = BULLET.instantiate()
	bullet.global_position = global_position + Vector2(0, 8)
	bullet.direction = Vector2.DOWN
	bullet.speed = 100
	get_tree().root.add_child(bullet)


func _on_area_entered(area: PlayerBullet) -> void:
	if not area:
		return

	take_damage(area.player)
	area.take_damage()
