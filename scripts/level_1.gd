extends Node

signal health_depleted
@export var scroll_speed := Vector2(0, 500)
var game_over_scene = load("res://scenes/menu/game_over.tscn")
var speed: float
const START_SPEED : float = 10.0
const SCORE_MODIFIER: int = 10
const SPEED_MODIFIER: int = 10000
var score: int 
var game_running: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play()
	$HUD/Button.hide()
	$HUD/HealthBar.hide()
	$Menu.hide()
	$Menu.get_node("MarginContainer/VBoxContainer/Resume").pressed.connect(resume_game)
	$HUD.get_node("Button").pressed.connect(pause_game)
	Global.lives = 100     #change back later to 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Player.position.x = clamp($Player.position.x, 300, 880)
	$Player.position.y = clamp($Player.position.y, 70, 600)
	if Input.is_action_pressed("ui_accept"):
		game_running = true
		hide_hud()
		
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		$ParallaxBackground.scroll_offset += scroll_speed * delta
		#$Player.position.y -= speed
		#$Camera2D.position.y -= speed  
		#$MeleeEnemy.position.y -= speed  
		score += speed
		show_score()
	
	if Global.score1 < score:
		Global.score1 = score
		
	if Global.lives <= 0:
		health_depleted.emit()
		game_over()


func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score/SCORE_MODIFIER)
	$HUD/Button.show()
	$HUD/HealthBar.show()

func _unhandled_input(event):		
	if event.is_action_pressed("ui_cancel"):
		if !game_running:
			hide_hud()
			resume_game()
		else:
			pause_game()


func resume_game():
	game_running = true
	$Player.show()
	$MeleeEnemy.show()
	$Menu.hide()
	MusicPlayer.play()


func pause_game():
	$Menu.show()
	game_running = false
	$Player.hide()
	$MeleeEnemy.hide()
	$ParallaxBackground.scroll_speed = Vector2(0, 0)
	MusicPlayer.stop()


func hide_hud():
	$HUD.get_node("Label").hide()
	$HUD.get_node("Label2").hide()

func game_over():
	game_running = false
	#$MeleeEnemy.set_process_input(false)
	#get_tree().paused = true
	$ParallaxBackground.scroll_speed = Vector2(0, 0)
	MusicPlayer.stop()
	get_node(".").add_child(game_over_scene.instantiate())
