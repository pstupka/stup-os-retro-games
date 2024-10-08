extends Label

var score: int = 0:
	set(new_score):
		score = new_score
		text = "%012d" % score


func init(player: Player) -> void:
	score = player.score
	player.score_changed.connect(_on_player_score_changed)


func _on_player_score_changed(new_score: int) -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "score", new_score, 1).from_current()
