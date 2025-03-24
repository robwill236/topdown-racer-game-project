extends CharacterBody2D


const SPEED = 100.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var _player_detection_system: DetectionSystem

func _ready():
	_player_detection_system = get_player_detection_system()
	navigation_agent_2d.target_desired_distance = 80.0

func _physics_process(delta):
	var target_position = _player_detection_system.get_right_detector_position()
	navigation_agent_2d.target_position = target_position
	
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var direction = (next_path_position - position).normalized()
	
	if navigation_agent_2d.is_navigation_finished():
		print("stop")
	else:
		velocity = direction * SPEED
	
	move_and_slide()

func get_player_detection_system() -> DetectionSystem:
	var player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)

	return player_ref.get_node("DetectionSystem")

func attack():
	pass
