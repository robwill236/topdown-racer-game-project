extends Node2D

func _on_right_detector_body_entered(body):
	SignalManager.right_detection.emit("right", true)


func _on_right_detector_body_exited(body):
	SignalManager.right_detection.emit("right", false)


func _on_left_detector_body_entered(body):
	SignalManager.left_detection.emit("left", true)


func _on_left_detector_body_exited(body):
	SignalManager.left_detection.emit("left", false)
