extends Bullet
class_name PlayerBullet


var player: Player
var pierce: int = 0


func _ready() -> void:
	super._ready()


func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta


func take_damage() -> void:
	pierce -= 1
	if pierce < 0:
		queue_free()
