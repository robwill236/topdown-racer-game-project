extends Node

var speed: float
const START_SPEED : float = 10.0
const SCORE_MODIFIER: int = 10
const SPEED_MODIFIER: int = 5000
var score: int 
var game_running: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		
		$Player.position.x += speed
		#$Player/Camera2D.position.x += speed
		score += speed
		show_score()
		
		if $Player.position == $FinishSign.position:
			speed = 0
			score = 0
		
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("Label").hide()
			$HUD.get_node("Label2").hide()

func new_game():
	score = 0
	show_score()
	$HUD.get_node("Label").show()
	$HUD.get_node("Label2").show()
	
	$Player.velocity = Vector2i(0, 0)


func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score/SCORE_MODIFIER)
