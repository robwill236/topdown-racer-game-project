extends Node2D

func _on_right_detector_body_entered(body):
	SignalManager.right_detection.emit(Constants.RIGHT_SIDE_DETECTOR, true)


func _on_right_detector_body_exited(body):
	SignalManager.right_detection.emit(Constants.RIGHT_SIDE_DETECTOR, false)


func _on_left_detector_body_entered(body):
	SignalManager.left_detection.emit(Constants.LEFT_SIDE_DETECTOR, true)


func _on_left_detector_body_exited(body):
	SignalManager.left_detection.emit(Constants.LEFT_SIDE_DETECTOR, false)
