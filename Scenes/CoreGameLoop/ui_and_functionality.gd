extends Node

var in_play := false
var current_round := 0
var max_rounds := 5
var round_length:= 40
var round_pause:= 12

@onready var round_label = $CanvasLayer/CenterContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	await get_tree().create_timer(2).timeout
	for i in range(max_rounds):	
		await start_round(i+1, 5, round_length)
		await get_tree().create_timer(round_pause).timeout
		
	await get_tree().create_timer(5).timeout
	round_label.text = "YOU WIN!"	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_round(round: int, startTimer: int, roundLength: int) -> void:
	current_round = round
	in_play = false

	for i in range(startTimer - 1, -1, -1):
		round_label.text = str(i)
		await get_tree().create_timer(1).timeout

	round_label.text = "GO!"	
	in_play = true
	await get_tree().create_timer(1).timeout
	round_label.text = "ROUND %d\n" % round	
	for i in range(roundLength - 1, -1, -1):
		round_label.text = "ROUND %d\n%d" % [round, i]
		await get_tree().create_timer(1).timeout
	
	round_label.text = "ROUND %d COMPLETE!" % round
	in_play = false
