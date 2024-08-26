extends Node
class_name Utils

static func blink_node(node: Node, blink: bool = true) -> void:
	if not node:
		return

	var tween: Tween = node.create_tween().set_loops()
	tween.tween_callback(node.show).set_delay(0.4)
	tween.tween_callback(node.hide).set_delay(0.4)
