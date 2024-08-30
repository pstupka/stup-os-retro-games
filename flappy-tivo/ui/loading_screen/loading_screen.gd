extends CanvasLayer

@onready var pivot: Control = $Pivot
@export var loading_speed: float = 300.0
@export var loading_time: float = 1.4
@onready var loading_texture: TextureRect = $Pivot/LoadingTexture


func _ready():
	show()
	Events.loading_finished.connect(_on_loading_finished)
	Events.call_deferred("emit_signal", "loading_started")
	var tween: Tween = create_tween()
	tween.tween_callback(Events.loading_finished.emit).set_delay(loading_time)


func _physics_process(delta: float) -> void:
	loading_texture.rotation_degrees += loading_speed * delta


func _on_loading_finished() -> void:
	var tween: Tween = create_tween()
	tween.parallel().tween_property(pivot, "modulate:a", 0.0, 0.2)
	tween.tween_callback(call_deferred.bind("queue_free"))
