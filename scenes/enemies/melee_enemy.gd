extends CharacterBody2D


const SPEED = 100.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _player_detection_system: DetectionSystem

func _ready():
	_player_detection_system = get_player_detection_system()

func _physics_process(delta):
	var direction = (_player_detection_system.get_right_detector_position() - position).normalized()
	
	velocity = direction * SPEED
	move_and_slide()

func get_player_detection_system() -> DetectionSystem:
	var player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)

	return player_ref.get_node("DetectionSystem")

func attack():
	animation_player.play("attack")
