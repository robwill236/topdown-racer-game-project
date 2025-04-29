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
	if Input.is_action_pressed("ui_accept"):
		game_running = true
		$HUD.get_node("Label").hide()
		$HUD.get_node("Label2").hide()
		
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		$ParallaxBackground.scroll_speed += scroll_speed * delta
		#$Player.position.y -= speed
		#$Camera2D.position.y -= speed  
		#$MeleeEnemy.position.y -= speed  
		$Player.position.x = clamp($Player.position.x, 300, 880)
		score += speed
	show_score()


func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score/SCORE_MODIFIER)
	$HUD/Button.show()
	$HUD/Button2.show()


func _unhandled_input(event):		
	if event.is_action_pressed("ui_cancel"):
		#get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
		#get_node(".").add_child(pause_menu.instantiate())
		#get_tree().root.add_child(pause_menu.instantiate())
		pause_game()

func resume_game():
	game_running = true
	$Menu.hide()


func quit_game():
	get_tree().quit()


func pause_game():
	$Menu.show()
	game_running = false
	$ParallaxBackground.scroll_speed = Vector2(0, 0)
