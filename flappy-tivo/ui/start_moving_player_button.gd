extends AnimatedSprite2D

@onready var hand: Sprite2D = $Hand
@onready var hand_2: Sprite2D = $Hand2


func _ready() -> void:
	var tween: Tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(hand, "position:x", -24, 0.2)
	tween.parallel().tween_property(hand_2, "position:x", 24, 0.2)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(hand, "position:x", -20, 0.3)
	tween.parallel().tween_property(hand_2, "position:x", 20, 0.3)
