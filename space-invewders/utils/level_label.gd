extends Label
class_name LevelLabel


func unroll_and_hide(unroll_time: float, hide_delay: float) -> void:
	self.visible = true
	var tween: Tween = create_tween()
	tween.tween_property(self, "visible_ratio",1, unroll_time).from(0)
	tween.tween_callback(self.hide).set_delay(hide_delay/5)
	tween.tween_callback(self.show).set_delay(hide_delay/5)
	tween.tween_callback(self.hide).set_delay(hide_delay/5)
	tween.tween_callback(self.show).set_delay(hide_delay/5)
	tween.tween_callback(self.hide).set_delay(hide_delay/5)
