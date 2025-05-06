extends Node

@onready var enemy_spawn_points = $EnemySpawnPoints
@onready var enemy_scene = preload("res://scenes/enemies/melee_enemy.tscn")
@onready var enemy_spawner: Timer = $EnemySpawner

@export var scroll_speed := Vector2(0, 500)
var game_over_scene = load("res://scenes/menu/game_over.tscn")
var speed: float
const START_SPEED : float = 10.0
const SCORE_MODIFIER: int = 10
const SPEED_MODIFIER: int = 10000
const MAX_ENEMIES: int = 2
@onready var pause: AudioStreamPlayer = $Pause
var finish_scene = load("res://scenes/menu/finish.tscn")
var score: int 
var game_running: bool
var enemies_to_beat: int = 5
var enemy_counter: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.lives = 10
	MusicPlayer.play()
	$HUD/Button.hide()
	$HUD/HealthBar.hide()
	$Finish.hide()
	$Menu.hide()
	$Menu.get_node("MarginContainer/VBoxContainer/Resume").pressed.connect(resume_game)
	$HUD.get_node("Button").pressed.connect(pause_game)
	check_melee_enemy("stop")
	check_player("stop")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Player.position.x = clamp($Player.position.x, 300, 880)
	$Player.position.y = clamp($Player.position.y, 70, 600)
	if Input.is_action_pressed("ui_accept"):
		game_running = true
		check_melee_enemy("resume")
		check_player("resume")
		hide_hud()
		
	if game_running:
		$ParallaxBackground.scroll_offset += scroll_speed * delta
		score = Global.points
		show_score()
		
	if Global.lives <= 0:
		game_over()
		
	if Global.points == 10:
		finish()

func spawn_enemy() -> void:
	var spawn_points = enemy_spawn_points.get_children()
	
	var random_marker = spawn_points[randi() % spawn_points.size()]
	var enemy = enemy_scene.instantiate()
	
	enemy.global_position = random_marker.global_position
	get_parent().add_child(enemy)

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score)
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
	$Menu.hide()
	check_melee_enemy("resume")
	check_player("resume")
	MusicPlayer.play()
	pause.stop() 


func pause_game():
	$Menu.show()
	check_melee_enemy("stop")
	check_player("stop")
	stop()
	pause.play()
	
func stop():
	game_running = false
	$ParallaxBackground.scroll_speed = Vector2(0, 0)
	MusicPlayer.stop()

func hide_hud():
	$HUD.get_node("Label").hide()
	$HUD.get_node("Label2").hide()

func game_over():
	Global.current1 = score
	if Global.score1 < score:
		Global.score1 = score 
	stop()
	get_node(".").add_child(game_over_scene.instantiate())

func _on_enemy_spawner_timeout():
	if enemy_counter >= enemies_to_beat:
		enemy_spawner.stop()
		return
	
	var current_enemies = get_tree().get_nodes_in_group(Constants.ENEMIES_GROUP).size()
	
	if current_enemies == MAX_ENEMIES:
		return

	spawn_enemy()
	enemy_counter += 1

func finish():
	stop()
	pause.play()
	$Finish.monitoring = true
	score = Global.points * Global.lives
	Global.current1 = score
	if Global.score1 < score:
		Global.score1 = score
	$Finish.show()
	

func check_melee_enemy(value : String):
	var melee = get_node_or_null("MeleeEnemy")
	if melee != null:
		if value == "stop":
			$MeleeEnemy.stop_process()
		else:
			$MeleeEnemy.resume_process()
		
			
func check_player(value : String):
	var player = get_node_or_null("Player")
	if player != null:
		if value == "stop":
			$Player.stop_process()
		else:
			$Player.resume_process()
		

func _on_finish_body_entered(body: Node2D) -> void:
	get_node(".").add_child(finish_scene.instantiate())
	check_player("stop")	

