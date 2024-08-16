extends HBoxContainer
class_name PlayerLivesIndicator


@export var texture: Texture2D


func init(player: Player) -> void:
	for i in range(player.lives):
		add_lives(1)
	player.lives_changed.connect(_on_player_lives_changed)


func add_lives(lives_number: int) -> void:
	for i in lives_number:
		var texture_rect = TextureRect.new()
		texture_rect.texture = texture
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
		add_child(texture_rect)


func remove_lives(lives_number: int) -> void:
	for i in lives_number:
		if get_child_count() > 0:
			get_children().back().queue_free()


func _on_player_lives_changed(lives: int) -> void:
	var lives_delta = lives - get_child_count()
	if lives_delta > 0:
		add_lives(lives_delta)
	if lives_delta < 0:
		remove_lives(abs(lives_delta))
	#var current_lives = lives_indicator_container.get_child_count()
	#if lives > current_lives:
		#for i in range(lives - current_lives):
			#var sprite = Sprite2D.new()
			#sprite.texture = lives_texture
			#lives_indicator_container.add_child(sprite)
	#if lives < current_lives:
		#var lives_indicator_sprites = lives_indicator_container.get_children()
		#for i in range(current_lives - lives):
			#lives_indicator_sprites.pop_back().queue_free()
