extends Area2D

enum SpawnSide {
	TOP,
	LEFT,
	RIGHT
}

@export var side : SpawnSide = SpawnSide.TOP
@export var bomb_scene : PackedScene
@export var spawn_size := Vector2(800, 50)
@onready var game_manager = get_tree().current_scene.get_node("GameManager")
var spawn_timer := 0.0



func _process(delta: float) -> void:
	if !game_manager.in_play:
		return

	spawn_timer -= delta

	if spawn_timer <= 0:
		spawn_bomb()
		spawn_timer = get_spawn_delay()


func get_spawn_delay() -> float:
	match game_manager.current_round:
		1:
			return randf_range(1.2, 2.0)
		2:
			return randf_range(0.9, 1.6)
		3:
			return randf_range(0.7, 1.3)
		4:
			return randf_range(0.5, 1.0)
		5:
			return randf_range(0.35, 0.75)

	return 1.0


func spawn_bomb() -> void:
	var bomb = bomb_scene.instantiate()



	match side:
		SpawnSide.TOP:
			bomb.direction = bomb.Direction.DOWN
		SpawnSide.LEFT:
			bomb.direction = bomb.Direction.LEFT_TO_RIGHT
		SpawnSide.RIGHT:
			bomb.direction = bomb.Direction.RIGHT_TO_LEFT
	bomb.global_position = get_random_spawn_position()
	get_tree().current_scene.add_child(bomb)
	
func get_random_spawn_position() -> Vector2:
	return global_position + Vector2(
		randf_range(-spawn_size.x * 0.5, spawn_size.x * 0.5),
		randf_range(-spawn_size.y * 0.5, spawn_size.y * 0.5)
	)
