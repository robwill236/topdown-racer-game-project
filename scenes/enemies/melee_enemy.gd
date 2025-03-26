extends CharacterBody2D

const SPEED = 100.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var avoidance_timer: Timer = $AvoidanceTimer

var _player_detection_system: DetectionSystem
var _avoidance_vector: Vector2 = Vector2.ZERO


func _ready():
	_player_detection_system = get_player_detection_system()

func _physics_process(delta):
	var direction = (_player_detection_system.get_right_detector_position() - position).normalized()
	
	velocity = (direction + _avoidance_vector) * SPEED
	move_and_slide()

func get_player_detection_system() -> DetectionSystem:
	var player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)

	return player_ref.get_node("DetectionSystem")

func attack():
	animation_player.play("attack")

func _on_avoidance_timer_timeout():
	_avoidance_vector = Vector2.ZERO

func _on_detector_body_entered(body):
	var away_from_obstacle = (position - body.global_position).normalized()
	var perpendicualr = away_from_obstacle.orthogonal()
	_avoidance_vector = perpendicualr * 4.0
	avoidance_timer.start()
