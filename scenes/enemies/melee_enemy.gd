extends CharacterBody2D

const SPEED = 100.0
const DISTANCE_THRESHOLD = 25.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var avoidance_timer: Timer = $AvoidanceTimer
@onready var detector: Area2D = $Detector
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sfx_kicking: AudioStreamPlayer = $sfx_kicking


var _player_detection_system: DetectionSystem
var _player_detectors: Dictionary = {
	Constants.LEFT_SIDE_DETECTOR: false, 
	Constants.RIGHT_SIDE_DETECTOR: false
}
var _current_target: String
var _avoidance_vector: Vector2 = Vector2.ZERO
var _health: int = 30


func _ready():
	SignalManager.left_detection.connect(set_detector)
	SignalManager.right_detection.connect(set_detector)
	SignalManager.on_hit.connect(take_damage)
	_player_detection_system = get_player_detection_system()

func _physics_process(delta):
	var direction = get_direction_to_target()
	var target_position = _player_detection_system.get_left_detector_position() if _current_target == Constants.LEFT_SIDE_DETECTOR else _player_detection_system.get_right_detector_position()
	var distance_to_target = position.distance_to(target_position)
	
	if distance_to_target <= DISTANCE_THRESHOLD:
		velocity = Vector2.ZERO
	else:
		velocity = (direction + _avoidance_vector) * SPEED

	move_and_slide()

func set_detector(detection_side: String, is_detected: bool):
	_player_detectors[detection_side] = is_detected

func get_direction_to_target() -> Vector2:
	var right_detector_position = _player_detection_system.get_right_detector_position()
	var left_detector_position = _player_detection_system.get_left_detector_position()
	
	if _player_detectors[Constants.LEFT_SIDE_DETECTOR] and !_player_detectors[Constants.RIGHT_SIDE_DETECTOR]:
		return (right_detector_position - position).normalized()
	elif _player_detectors[Constants.RIGHT_SIDE_DETECTOR] and !_player_detectors[Constants.LEFT_SIDE_DETECTOR]:
		return (left_detector_position - position).normalized()
	
	var right_detector_distance = position.distance_to(right_detector_position)
	var left_detector_distance = position.distance_to(left_detector_position)
	
	if right_detector_distance < left_detector_distance:
		_current_target = Constants.RIGHT_SIDE_DETECTOR
		return (right_detector_position - position).normalized()
	else:
		_current_target = Constants.LEFT_SIDE_DETECTOR
		return (left_detector_position - position).normalized()

func get_player_detection_system() -> DetectionSystem:
	var player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	return player_ref.get_node("DetectionSystem")

func evaluate_attack_position(player_side: String) -> void:
	if _current_target != player_side:
		return
	
	attack()

func attack() -> void:
	detector.monitoring = false
	print("hit")
	if _current_target == Constants.LEFT_SIDE_DETECTOR:
		sprite_2d.flip_h = false
	else:
		sprite_2d.flip_h = true

	animation_player.play("attack")
	sfx_kicking.play()
	SignalManager.on_hit.emit(20, self)

func back_to_monitoring() -> void:
	detector.monitoring = true

func take_damage(damage: int, source: Node) -> void:
	if source.is_in_group(Constants.PLAYER_GROUP):
		_health -= damage
	
	if _health <= 0:
		queue_free()

func _on_avoidance_timer_timeout():
	_avoidance_vector = Vector2.ZERO

func _on_detector_body_entered(body):
	var away_from_obstacle = (position - body.global_position).normalized()
	var perpendicualr = away_from_obstacle.orthogonal()
	_avoidance_vector = perpendicualr * 4.0
	avoidance_timer.start()
