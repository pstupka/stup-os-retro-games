extends Area2D

@onready var posters: Node2D = $Posters
@onready var score_area: Area2D = $ScoreArea
@onready var score_selector: Sprite2D = $ScoreSelector
@onready var score_particles: GPUParticles2D = $ScoreParticles
@onready var outlines: Node2D = $Outlines


func _ready() -> void:
	for sprite in posters.get_children():
		sprite.texture = load("res://assets/sprites/posters/%d.png" % randi_range(1, 195))
	score_area.area_entered.connect(_on_score_area_entered)


func _on_score_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		var tween: Tween = create_tween()
		tween.tween_property(score_selector, "modulate", Color.GOLD, 0.04)
		tween.tween_property(score_selector, "modulate", Color("00a7e1"), 0.1).set_delay(0.3)

		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(score_selector, "scale", Vector2(1, 1), 0.4).from(Vector2(1.3, 1.3))

		tween = score_selector.create_tween()
		tween.tween_property(outlines, "modulate", Color("00a7e1"), 0.2)

		score_particles.emitting = true
