extends Area2D
class_name Bullet


@export var speed: float = 300.0
@export var direction: Vector2 = Vector2.UP


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta


func take_damage() -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bounds"):
		queue_free()
