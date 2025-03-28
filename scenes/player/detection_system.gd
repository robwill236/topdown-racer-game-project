extends Node2D

class_name DetectionSystem

@onready var right_detector = $RightDetector
@onready var left_detector = $LeftDetector

func get_right_detector_position() -> Vector2:
	return right_detector.global_position + Vector2(50, 0)

func get_left_detector_position() -> Vector2:
	return left_detector.global_position + Vector2(-50, 0)

func _on_right_detector_body_entered(body: CharacterBody2D):
	#This if is just temporary to get the enemy to react
	if body.is_in_group(Constants.ENEMIES_GROUP):
		body.evaluate_attack_position(Constants.RIGHT_SIDE_DETECTOR)

	SignalManager.right_detection.emit(Constants.RIGHT_SIDE_DETECTOR, true)


func _on_right_detector_body_exited(body):
	#This if is just temporary to get the enemy to react
	if body.is_in_group(Constants.ENEMIES_GROUP):
		body.back_to_monitoring()

	SignalManager.right_detection.emit(Constants.RIGHT_SIDE_DETECTOR, false)


func _on_left_detector_body_entered(body):
	#This if is just temporary to get the enemy to react
	if body.is_in_group(Constants.ENEMIES_GROUP):
		body.evaluate_attack_position(Constants.LEFT_SIDE_DETECTOR)

	SignalManager.left_detection.emit(Constants.LEFT_SIDE_DETECTOR, true)


func _on_left_detector_body_exited(body):
	#This if is just temporary to get the enemy to react
	if body.is_in_group(Constants.ENEMIES_GROUP):
		body.back_to_monitoring()

	SignalManager.left_detection.emit(Constants.LEFT_SIDE_DETECTOR, false)
