extends CharacterBody2D

enum PlayerState { IDLE, ATTACK }

@export var speed: float = 250.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visual: Node2D = $Visual


const MARGIN: float = 32

var _state: PlayerState = PlayerState.IDLE
var _upper_left: Vector2
var _lower_right: Vector2
var _is_attack_anim_finished: bool = true
var _left_detector: bool = false
var _right_detector: bool = false

func _ready():
	set_limits()
	SignalManager.left_detection.connect(set_left_detector)
	SignalManager.right_detection.connect(set_right_detector)
	

func _process(delta):
	var input = get_movement_input()
	position += input * delta * speed
	position = position.clamp(_upper_left, _lower_right)
	
	calculate_states()

func get_movement_input() -> Vector2:
	var player_vector = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	return player_vector.normalized()

func set_limits() -> void:
	var vp = get_viewport_rect()
	_lower_right = Vector2(vp.size.x - MARGIN, vp.size.y - MARGIN)
	_upper_left = Vector2(MARGIN, MARGIN)

func set_state(new_state: PlayerState) -> void:
	if new_state == _state:
		return
	
	if !_is_attack_anim_finished:
		return

	_state = new_state
	
	match _state:
		PlayerState.IDLE:
			animation_player.play("idle")
		PlayerState.ATTACK:
			flip_player()
			_is_attack_anim_finished = false
			animation_player.play("attack")

func calculate_states() -> void:
	if Input.is_action_just_pressed("attack"):
		set_state(PlayerState.ATTACK)
	elif get_movement_input() != Vector2.ZERO:
		set_state(PlayerState.IDLE)
	else:
		set_state(PlayerState.IDLE)

func flip_player() -> void:
	if _left_detector and !_right_detector:
		visual.scale.x = -1
	elif _right_detector and !_left_detector:
		visual.scale.x = 1
	else:
		visual.scale.x = 1

func set_left_detector(is_detected: bool):
	_left_detector = is_detected

func set_right_detector(is_detected: bool):
	_right_detector = is_detected

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		_is_attack_anim_finished = true

func _on_hitbox_body_entered(body):
	print(body)
