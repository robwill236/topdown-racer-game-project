extends Area2D

class_name ObstacleLane

@onready var obstacle_spawn_location: PathFollow2D = $ObstaclePath/ObstacleSpawnLocation

var is_player_detected: bool = false

func spawn_obstacle(scene: PackedScene):
	var obstacle = scene.instantiate()
	var ratio = randf()
	obstacle_spawn_location.progress_ratio = ratio
	obstacle.position = obstacle_spawn_location.position
	add_child(obstacle)

func _on_body_entered(body):
	if body.is_in_group(Constants.PLAYER_GROUP):
		is_player_detected = true


func _on_body_exited(body):
	if body.is_in_group(Constants.PLAYER_GROUP):
		is_player_detected = false
