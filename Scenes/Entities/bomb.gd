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

var velocity := Vector2.ZERO

func _ready():
	var sprite = $BombSprite

	match direction:
		Direction.DOWN:
			velocity = Vector2.DOWN
			sprite.rotation_degrees = 0

		Direction.LEFT_TO_RIGHT:
			velocity = Vector2.RIGHT
			sprite.rotation_degrees = 90

		Direction.RIGHT_TO_LEFT:
			velocity = Vector2.LEFT
			sprite.rotation_degrees = -90


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


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.hit()
		queue_free()
