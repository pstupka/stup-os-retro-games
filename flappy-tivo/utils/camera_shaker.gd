extends Camera2D
class_name Shaker

@export var decay := 0.8
@export var max_offset := Vector2(20, 20)

var trauma: float = 0.0
var initial_offset: Vector2


func _ready() -> void:
	randomize()
	Events.add_shake_trauma.connect(add_trauma)
	initial_offset = offset


func add_trauma(amount : float) -> void:
	trauma = min(trauma + amount, 1.0)


func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		offset.x = initial_offset.x + max_offset.x * trauma * randf_range(-0.5, 0.5)
		offset.y = initial_offset.y + max_offset.y * trauma * randf_range(-0.5, 0.5)
