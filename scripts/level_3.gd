extends Node

@export var scroll_speed := Vector2(0, 500)
var speed: float
const START_SPEED : float = 10.0
const SCORE_MODIFIER: int = 10
const SPEED_MODIFIER: int = 10000
const CAM_START_POS := Vector2i(576, 324)
var score: int 
var game_running: bool
var pause_menu = load("res://scenes/MainMenu.tscn")
var current_position = Vector2(0,0)
var max_x = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/Button.hide()
	$HUD/Button2.hide()
	$Menu.hide()
	$Menu.get_node("MarginContainer/VBoxContainer/Resume").pressed.connect(resume_game)
	$Menu.get_node("MarginContainer/VBoxContainer/Quit").pressed.connect(quit_game)
	$HUD.get_node("Button").pressed.connect(pause_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Player.position.x = clamp($Player.position.x, 320, 850)
	if Input.is_action_pressed("ui_accept"):
		game_running = true
		$HUD.get_node("Label").hide()
		$HUD.get_node("Label2").hide()
		
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		$ParallaxBackground.scroll_offset += scroll_speed * delta
		
		score += speed
		show_score()


func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score/SCORE_MODIFIER)
	$HUD/Button.show()
	$HUD/Button2.show()

func resume_game():
	game_running = true
	$Menu.hide()


func quit_game():
	get_tree().quit()


func pause_game():
	$Menu.show()
	game_running = false
	$ParallaxBackground.scroll_speed = Vector2(0, 0)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if !game_running:
			resume_game()
		else:
			pause_game()
