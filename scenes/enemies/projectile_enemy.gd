extends CharacterBody2D

enum EnemyState { RETREAT, CHARGE, SHOOT }

const RETREAT_DISTANCE = 100.0
const SHOOT_DISTANCE = 150.0
const SPEED = 80.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wall_detector: Area2D = $WallDetector
@onready var attack_timer: Timer = $AttackTimer
@onready var projectile_scene = preload("res://Projectile.tscn")
@onready var visual: Node2D = $Visual

var _state: EnemyState = EnemyState.RETREAT
var _player_ref: Node2D
var _escape_direction: Vector2 = Vector2.ZERO

func _ready():
	_player_ref = get_tree().get_first_node_in_group("Player")
	attack_timer.start()

func _physics_process(delta):
	if not _player_ref:
		return

	var to_player = _player_ref.global_position - global_position
	var distance = to_player.length()

	match _state:
		EnemyState.RETREAT:
			if distance > SHOOT_DISTANCE:
				set_state(EnemyState.CHARGE)
			else:
				escape_from_player(to_player)
		EnemyState.CHARGE:
			velocity = Vector2.ZERO
		EnemyState.SHOOT:
			velocity = Vector2.ZERO

	move_and_slide()
	clamp_to_screen()

func escape_from_player(to_player: Vector2):
	var direction = -to_player.normalized()

	if wall_detector.get_overlapping_bodies().size() > 0:
		direction = direction.orthogonal()  # sidestep if near wall

	velocity = direction * SPEED

func clamp_to_screen():
	var screen_rect = get_viewport().get_visible_rect()
	global_position.x = clamp(global_position.x, screen_rect.position.x, screen_rect.end.x)
	global_position.y = clamp(global_position.y, screen_rect.position.y, screen_rect.end.y)

func set_state(new_state: EnemyState):
	if new_state == _state:
		return

	_state = new_state

	match _state:
		EnemyState.RETREAT:
			animation_player.play("run")
		EnemyState.CHARGE:
			animation_player.play("charge")
			await animation_player.animation_finished
			set_state(EnemyState.SHOOT)
		EnemyState.SHOOT:
			animation_player.play("shoot")
			shoot_projectile()
			await animation_player.animation_finished
			set_state(EnemyState.RETREAT)

func shoot_projectile():
	if not _player_ref:
		return

	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.direction = (_player_ref.global_position - global_position).normalized()

func _on_attack_timer_timeout():
	if _state == EnemyState.RETREAT:
		set_state(EnemyState.CHARGE)
