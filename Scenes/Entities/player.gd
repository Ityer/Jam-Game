extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var invulnerable := false

@export var health:int = 3
@onready var ui = get_tree().current_scene.get_node("GameManager")
@onready var sprite = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		ui.jumpPlay()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	handleAnimation()
	move_and_slide()
	
	
func hit():
	if invulnerable:
		return

	health -= 1
	ui.set_health(health, 3)

	invulnerable = true

	flash()

	await get_tree().create_timer(3.0).timeout
	invulnerable = false
	sprite.visible = true
	
	
func handleAnimation():
	if !is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif velocity.x > 0:
		$AnimatedSprite2D.play("right")
	elif velocity.x < 0:
		$AnimatedSprite2D.play("left")
	else:
		$AnimatedSprite2D.play("idle")
		
func flash():
	while invulnerable:
		sprite.visible = false
		await get_tree().create_timer(0.1).timeout

		sprite.visible = true
		await get_tree().create_timer(0.1).timeout		
