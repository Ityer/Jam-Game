extends Node

var in_play := false
var game_over:= false
var current_round := 0
var max_rounds := 5
var round_length:= 40
var round_pause:= 12
@export var heart_scene: PackedScene

@onready var round_label = $CanvasLayer/CenterContainer/Label
@onready var popup = $CanvasLayer/UI/Popup
@onready var hearts = $CanvasLayer/UI/Hearts
@onready var music = $gameMusic
@onready var explode = $explode
@onready var jump = $jump
@onready var player = get_tree().current_scene.get_node("Player")





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_health(3, 3)
	popup.hide()
	await startGame()
	
	
func startGame():
	await get_tree().create_timer(2).timeout
	music.play(0.0)
	for i in range(max_rounds):
		await start_round(i+1, 5, round_length)		
		if game_over: return
		await get_tree().create_timer(round_pause).timeout		
		if game_over: return
			
	await get_tree().create_timer(5).timeout
	round_label.text = "YOU WIN!"	



func start_round(roundid: int, startTimer: int, roundLength: int) -> void:
	current_round = roundid
	in_play = false
	game_over = false
	player.health = 3
	set_health(3,3)

	for i in range(startTimer - 1, -1, -1):
		round_label.text = str(i)
		await get_tree().create_timer(1).timeout
	
	round_label.text = "GO!"	
	in_play = true
	await get_tree().create_timer(1).timeout
	if game_over: return
	round_label.text = "ROUND %d\n" % roundid	
	for i in range(roundLength - 1, -1, -1):
		round_label.text = "ROUND %d\n%d" % [roundid, i]
		await get_tree().create_timer(1).timeout
		if game_over: return
		
	round_label.text = "ROUND %d COMPLETE!" % roundid
	in_play = false


func set_health(current: int, maximum: int):
	# Remove existing hearts
	for child in hearts.get_children():
		child.queue_free()

	# Create new ones
	for i in maximum:
		var heart = heart_scene.instantiate()

		if i >= current:
			heart.modulate = Color(0.3, 0.3, 0.3) # empty heart

		hearts.add_child(heart)
		
		if current == 0:
			in_play = false
			game_over = true
			round_label.text = ""
			popup.show()
			for bomb in get_tree().get_nodes_in_group("bombs"):
				bomb.queue_free()


func _on_button_pressed() -> void:
	popup.hide()
	player.health = 3
	startGame()

func explodePlay():
	explode.play(0.0)
	
func jumpPlay():
	jump.play(0.0)
