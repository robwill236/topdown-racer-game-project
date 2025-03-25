extends CharacterBody2D


const SPEED = 100.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var avoidance_timer: Timer = $AvoidanceTimer

var _player_detection_system: DetectionSystem
var _avoidance_vector: Vector2 = Vector2.ZERO

func _ready():
	_player_detection_system = get_player_detection_system()
	navigation_agent_2d.target_desired_distance = 30.0

func _physics_process(delta):
	var target_position = _player_detection_system.get_right_detector_position()
	print(target_position)
	navigation_agent_2d.target_position = target_position
	
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var direction = (next_path_position - position).normalized()
	
	if navigation_agent_2d.is_navigation_finished():
		velocity = Vector2.ZERO
		print("stop")
	else:
		var final_direction = direction + _avoidance_vector
		velocity = final_direction.normalized() * SPEED
	
	move_and_slide()

func get_player_detection_system() -> DetectionSystem:
	var player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)

	return player_ref.get_node("DetectionSystem")

func attack():
	pass


func _on_detector_body_entered(body):
	var away_from_obstacle = (position - body.global_position).normalized()
	var perpendicualr = away_from_obstacle.orthogonal()
	_avoidance_vector = perpendicualr * 5.0
	avoidance_timer.start()

func _on_avoidance_timer_timeout():
	_avoidance_vector = Vector2.ZERO
