extends Area2D

const POSTERS_ARRAY: Array[Texture] = [
	preload("res://assets/sprites/posters/poster_01.png"),
	preload("res://assets/sprites/posters/poster_02.png"),
	preload("res://assets/sprites/posters/poster_03.png"),
	preload("res://assets/sprites/posters/poster_04.png"),
	preload("res://assets/sprites/posters/poster_05.png"),
	preload("res://assets/sprites/posters/poster_06.png"),
	preload("res://assets/sprites/posters/poster_07.png"),
	preload("res://assets/sprites/posters/poster_08.png"),
	preload("res://assets/sprites/posters/poster_09.png"),
	preload("res://assets/sprites/posters/poster_10.png"),
	preload("res://assets/sprites/posters/poster_11.png"),
	preload("res://assets/sprites/posters/poster_12.png"),
	preload("res://assets/sprites/posters/poster_13.png"),
	preload("res://assets/sprites/posters/poster_14.png"),
	preload("res://assets/sprites/posters/poster_15.png"),
	preload("res://assets/sprites/posters/poster_16.png"),
	preload("res://assets/sprites/posters/poster_17.png"),
	preload("res://assets/sprites/posters/poster_18.png"),
	preload("res://assets/sprites/posters/poster_19.png"),
	preload("res://assets/sprites/posters/poster_20.png"),
	preload("res://assets/sprites/posters/poster_21.png"),
	preload("res://assets/sprites/posters/poster_22.png"),
	preload("res://assets/sprites/posters/poster_23.png"),
	preload("res://assets/sprites/posters/poster_24.png"),
	preload("res://assets/sprites/posters/poster_25.png"),
	preload("res://assets/sprites/posters/poster_26.png")
]
@onready var posters: Node2D = $Posters


func _ready() -> void:
	for sprite in posters.get_children():
		sprite.texture = POSTERS_ARRAY.pick_random()
