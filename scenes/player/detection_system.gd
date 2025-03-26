extends Node2D

class_name DetectionSystem

@onready var right_detector = $RightDetector
@onready var left_detector = $LeftDetector

func get_right_detector_position() -> Vector2:
	return right_detector.global_position + Vector2(50, 0)

func get_left_detector_position() -> Vector2:
	return left_detector.global_position

func _on_right_detector_body_entered(body: CharacterBody2D):
	if body.is_in_group(Constants.ENEMIES_GROUP):
		body.attack()

	SignalManager.right_detection.emit(Constants.RIGHT_SIDE_DETECTOR, true)


func _on_right_detector_body_exited(body):
	SignalManager.right_detection.emit(Constants.RIGHT_SIDE_DETECTOR, false)


func _on_left_detector_body_entered(body):
	if body.is_in_group(Constants.ENEMIES_GROUP):
		body.attack()

	SignalManager.left_detection.emit(Constants.LEFT_SIDE_DETECTOR, true)


func _on_left_detector_body_exited(body):
	SignalManager.left_detection.emit(Constants.LEFT_SIDE_DETECTOR, false)
