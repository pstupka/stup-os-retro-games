extends GPUParticles2D


func _ready() -> void:
	finished.connect(_on_particles_finished)


func _process(delta: float) -> void:
	position.x -= delta * 60


func _on_particles_finished() -> void:
	call_deferred("queue_free")
