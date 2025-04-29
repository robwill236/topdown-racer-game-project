extends CharacterBody2D

enum PlayerState { IDLE, ATTACK, STUNNED }

@export var speed: float = 250.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visual: Node2D = $Visual
@onready var stun_timer = $StunTimer

const MARGIN: float = 32

var _state: PlayerState = PlayerState.IDLE
var _health: int = 100
var _is_attack_anim_finished: bool = true
var _detectors: Dictionary = {
	Constants.LEFT_SIDE_DETECTOR: false, 
	Constants.RIGHT_SIDE_DETECTOR: false
}

func _ready():
	SignalManager.left_detection.connect(set_detector)
	SignalManager.right_detection.connect(set_detector)
	SignalManager.on_hit.connect(take_damage)

func _physics_process(delta):
	if _state != PlayerState.STUNNED:
		var input = get_movement_input()

		velocity = input * speed
		
		move_and_slide()

		calculate_states()

func get_movement_input() -> Vector2:
	var player_vector = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	return player_vector.normalized()

func set_state(new_state: PlayerState) -> void:
	if new_state == _state:
		return
	
	if !_is_attack_anim_finished and new_state != PlayerState.STUNNED:
		return

	_state = new_state
	
	match _state:
		PlayerState.IDLE:
			animation_player.play("idle")
		PlayerState.ATTACK:
			flip_player()
			_is_attack_anim_finished = false
			animation_player.play("attack")
		PlayerState.STUNNED:
			_is_attack_anim_finished = true
			animation_player.play("stun")
			stun_timer.start()

func calculate_states() -> void:
	if Input.is_action_just_pressed("attack"):
		set_state(PlayerState.ATTACK)
	elif get_movement_input() != Vector2.ZERO:
		set_state(PlayerState.IDLE)
	else:
		set_state(PlayerState.IDLE)

func flip_player() -> void:
	if _detectors[Constants.LEFT_SIDE_DETECTOR] and !_detectors[Constants.RIGHT_SIDE_DETECTOR]:
		visual.scale.x = -1
	elif _detectors[Constants.RIGHT_SIDE_DETECTOR] and !_detectors[Constants.LEFT_SIDE_DETECTOR]:
		visual.scale.x = 1
	else:
		visual.scale.x = 1

func take_damage(damage: int, source: Node) -> void:
	if source.is_in_group(Constants.ENEMIES_GROUP):
		_health -= damage
	
	print(_health)
	
	if _health <= 0:
		print(_health)

func set_detector(detection_side: String, is_detected: bool):
	_detectors[detection_side] = is_detected

func on_hazard_hit() -> void:
	set_state(PlayerState.STUNNED)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		_is_attack_anim_finished = true

func _on_hitbox_body_entered(body):
	SignalManager.on_hit.emit(20, self)


func _on_stun_timer_timeout():
	set_state(PlayerState.IDLE)
