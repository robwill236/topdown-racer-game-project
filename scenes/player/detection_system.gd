extends Node

func _on_right_detector_body_entered(body):
	SignalManager.right_detection.emit(true)

func _on_left_detector_body_entered(body):
	SignalManager.left_detection.emit(true)

func _on_right_detector_body_exited(body):
	SignalManager.right_detection.emit(false)

func _on_left_detector_body_exited(body):
	SignalManager.left_detection.emit(false)
