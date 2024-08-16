extends Bullet
class_name EnemyBullet

# This prevents both players to take hit in the same frame
var dealt_damage: bool = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta


func take_damage() -> void:
	dealt_damage = true
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	super._on_area_entered(area)

	var bullet: PlayerBullet = area as PlayerBullet
	if bullet:
		print("Bullet collided with a bullet")
		bullet.take_damage()
		if randf() > 0.1:
			take_damage()
