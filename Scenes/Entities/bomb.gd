extends Area2D

enum Direction {
	NONE,
	DOWN,
	LEFT_TO_RIGHT,
	RIGHT_TO_LEFT,
}

@export var speed := 300.0
@export var direction : Direction = Direction.DOWN
@export var height := 24.0
@export var floor_y := 615.0

@export var left_limit := -100.0
@export var right_limit := 1400.0
@export var bottom_limit := 0.0
@onready var ui = get_tree().current_scene.get_node("GameManager")
const EXPLOSION = preload("res://Assets/explosion.tscn")

var velocity := Vector2.ZERO

func _ready():
	var sprite = $BombSprite
	sprite.play("default")
	add_to_group("bombs")

	match direction:
		Direction.DOWN:
			velocity = Vector2.DOWN
			sprite.rotation_degrees = 90

		Direction.LEFT_TO_RIGHT:
			velocity = Vector2.RIGHT
			sprite.rotation_degrees = 0

		Direction.RIGHT_TO_LEFT:
			velocity = Vector2.LEFT
			sprite.rotation_degrees = 180


func _process(delta):
	position += velocity * speed * delta

	match direction:
		Direction.DOWN:
			# Bomb falls towards the floor
			$BombSprite.position.y = -height
			height = max(height - speed * delta, 0)

		Direction.LEFT_TO_RIGHT, Direction.RIGHT_TO_LEFT:
			# Bomb stays at its spawn height
			$BombSprite.position.y = 0

	# Shadow always follows the bomb horizontally
	$Shadow.global_position.x = global_position.x

	# Shadow always stays on the floor
	$Shadow.global_position.y = floor_y
	
	
	if global_position.y > floor_y + bottom_limit:
		queue_free()

	match direction:
		Direction.LEFT_TO_RIGHT:
			if global_position.x > right_limit:
				queue_free()

		Direction.RIGHT_TO_LEFT:
			if global_position.x < left_limit:
				queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.invulnerable:
			return

		var explosion = EXPLOSION.instantiate()
		get_tree().current_scene.add_child(explosion)
		explosion.global_position = global_position

		ui.explodePlay()
		body.hit()
		queue_free()
