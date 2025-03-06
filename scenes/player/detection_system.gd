extends Node2D

func _on_right_detector_body_entered(body):
	print("right")
	SignalManager.right_detection.emit(true)


func _on_right_detector_body_exited(body):
	SignalManager.right_detection.emit(false)


func _on_left_detector_body_entered(body):
	print("left")
	SignalManager.left_detection.emit(true)


func _on_left_detector_body_exited(body):
	SignalManager.left_detection.emit(false)
