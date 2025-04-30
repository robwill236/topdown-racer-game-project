extends Node

@export var obstacle_scene: PackedScene
@onready var obstacle_timer = $ObstacleTimer

const MIN_SPAWN_TIME: float = 2.5
const MAX_SPAWN_TIME: float = 5.0

var lanes: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	lanes = get_children().filter(func(c): return c is ObstacleLane)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_obstacle_timer_timeout():
	for lane in lanes:

		if lane.is_player_detected:
			lane.spawn_obstacle(obstacle_scene)
			
			var spawn_wait_time = randf_range(MIN_SPAWN_TIME, MAX_SPAWN_TIME)
			obstacle_timer.wait_time = spawn_wait_time
			break
