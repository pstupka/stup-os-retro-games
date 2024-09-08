extends VBoxContainer
class_name FlappyMenuButton

const BUTTON_FOCUS: StyleBoxFlat = preload("res://ui/main_menu/button_focus.tres")
const BUTTON_NORMAL: StyleBoxFlat = preload("res://ui/main_menu/button_normal.tres")
const BUTTON_DISABLED: StyleBoxFlat = preload("res://ui/main_menu/button_disabled.tres")
@onready var arrow_up: TextureRect = $ArrowUp
@onready var arrow_down: TextureRect = $ArrowDown
@onready var scroll_container: ScrollContainer = $ContentPanel/MarginContainer/ScrollContainer
@onready var options_container: VBoxContainer = $ContentPanel/MarginContainer/ScrollContainer/OptionsContainer
@onready var content_panel: Panel = $ContentPanel
@onready var menu_option_changed: AudioStreamPlayer = $Sfx/MenuOptionChanged


@export var arrows_disabled: bool = false
@export var init_options: Array[MenuOption] = []
var current_option_idx: int = 0
var options: Array = []
@export var is_disabled: bool = false:
	set(value):
		is_disabled = value
		if is_disabled:
			focus_mode = FOCUS_NONE
			if content_panel:
				content_panel.modulate.a = 0.7
			if options_container:
				options_container.modulate.a = 0.0
			if arrow_up:
				arrow_up.modulate.a = 0.0
			if arrow_down:
				arrow_down.modulate.a = 0.0
		else:
			focus_mode = FOCUS_ALL
			if content_panel:
				content_panel.modulate.a = 1.0
			if options_container:
				options_container.modulate.a = 1.0
			if arrow_up:
				arrow_up.modulate.a = 1.0
			if arrow_down:
				arrow_down.modulate.a = 1.0
@export var menu_hint: String = ""
@export var arrows_modulate: Color = Color.WHITE


func _ready() -> void:
	is_disabled = is_disabled
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	for option in init_options:
		var texture_rect: TextureRect = TextureRect.new()
		texture_rect.texture = option.option_texture
		texture_rect.modulate = option.modulate
		options_container.add_child(texture_rect)
	options = options_container.get_children()
	content_panel.pivot_offset = content_panel.size / 2
	arrow_up.self_modulate = arrows_modulate
	arrow_down.self_modulate = arrows_modulate
	eval_arrows()


func select_next() -> void:
	if current_option_idx + 1 >= options.size():
		return

	current_option_idx += 1
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(scroll_container.get_v_scroll_bar(), "value", options[current_option_idx].position.y, 0.2)
	tween.parallel().tween_property(arrow_down, "position:y", arrow_down.position.y, 0.2).from(arrow_down.position.y + 5)
	tween.tween_callback(eval_arrows)
	Events.menu_button_option_changed.emit(self, init_options[current_option_idx])
	menu_option_changed.play()


func select_previous() -> void:
	if current_option_idx - 1 < 0:
		return

	current_option_idx -= 1
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	tween.tween_property(scroll_container.get_v_scroll_bar(), "value", options[current_option_idx].position.y, 0.2)
	tween.parallel().tween_property(arrow_up, "position:y", arrow_up.position.y, 0.2).from(arrow_up.position.y - 5)
	tween.tween_callback(eval_arrows)
	Events.menu_button_option_changed.emit(self, init_options[current_option_idx])
	menu_option_changed.play()


func eval_arrows() -> void:
	if current_option_idx + 1 >= options.size():
		arrow_down.self_modulate.a = 0.0
	else:
		arrow_down.self_modulate.a = 1.0

	if current_option_idx - 1 < 0:
		arrow_up.self_modulate.a = 0.0
	else:
		arrow_up.self_modulate.a = 1.0


func animate_push(strength: float = 1.3) -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(content_panel, "scale", Vector2.ONE, 0.4).from(Vector2.ONE * strength)


func _on_focus_entered() -> void:
	content_panel.add_theme_stylebox_override("panel", BUTTON_FOCUS)
	animate_push()


func _on_focus_exited() -> void:
	content_panel.add_theme_stylebox_override("panel", BUTTON_NORMAL)
