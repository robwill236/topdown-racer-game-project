extends CharacterBody2D

enum EnemyState { FOLLOW, ATTACK, STUNNED }

const SPEED = 100.0
const DISTANCE_THRESHOLD = 25.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var avoidance_timer: Timer = $AvoidanceTimer
@onready var detector: Area2D = $Detector
@onready var sfx_kicking: AudioStreamPlayer = $sfx_kicking
@onready var stun_timer: Timer = $StunTimer
@onready var visual: Node2D = $Visual

var _state: EnemyState = EnemyState.FOLLOW
var _player_detection_system: DetectionSystem
var _player_detectors: Dictionary = {
	Constants.LEFT_SIDE_DETECTOR: false, 
	Constants.RIGHT_SIDE_DETECTOR: false
}
var _current_target: String
var _avoidance_vector: Vector2 = Vector2.ZERO
var _health: int = 30
var is_attacking: bool = false


func _ready():
	SignalManager.left_detection.connect(set_detector)
	SignalManager.right_detection.connect(set_detector)
	_player_detection_system = get_player_detection_system()

func _physics_process(delta):
	if _state != EnemyState.STUNNED and !is_attacking:
		var direction = get_direction_to_target()
		var target_position = _player_detection_system.get_left_detector_position() if _current_target == Constants.LEFT_SIDE_DETECTOR else _player_detection_system.get_right_detector_position()
		var distance_to_target = position.distance_to(target_position)

		if distance_to_target <= DISTANCE_THRESHOLD:
			set_state(EnemyState.ATTACK)
			velocity = Vector2.ZERO
		else:
			set_state(EnemyState.FOLLOW)
			velocity = (direction + _avoidance_vector) * SPEED

		move_and_slide()

func set_detector(detection_side: String, is_detected: bool):
	_player_detectors[detection_side] = is_detected

func set_state(new_state: EnemyState) -> void:
	if new_state == _state:
		return
	
	if is_attacking and new_state != EnemyState.STUNNED:
		return

	_state = new_state
	
	match _state:
		EnemyState.FOLLOW:
			animation_player.play("idle")
		EnemyState.ATTACK:
			attack()
		EnemyState.STUNNED:
			is_attacking = false
			animation_player.play("stun")
			stun_timer.start()

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

func attack() -> void:
	is_attacking = true
	detector.monitoring = false
	print("hit")
	if _current_target == Constants.LEFT_SIDE_DETECTOR:
		visual.scale.x = 1
	else:
		visual.scale.x = -1

	animation_player.play("attack")

func back_to_monitoring() -> void:
	detector.monitoring = true

func take_damage() -> void:
	_health -= 5

	if _health <= 0:
		queue_free()

func on_hazard_hit() -> void:
	set_state(EnemyState.STUNNED)

func _on_avoidance_timer_timeout():
	_avoidance_vector = Vector2.ZERO

func _on_detector_body_entered(body):
	var away_from_obstacle = (position - body.global_position).normalized()
	var perpendicualr = away_from_obstacle.orthogonal()
	_avoidance_vector = perpendicualr * 4.0
	avoidance_timer.start()

func _on_stun_timer_timeout():
	back_to_monitoring()
	set_state(EnemyState.FOLLOW)


func _on_hurtbox_area_entered(area):
	if area.is_in_group(Constants.PLAYER_GROUP):
		take_damage()


func _on_hitbox_body_entered(body):
	sfx_kicking.play()
	SignalManager.on_hit.emit(20, self)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false
		back_to_monitoring()
		set_state(EnemyState.FOLLOW)
		
