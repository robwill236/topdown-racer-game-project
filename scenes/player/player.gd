extends CharacterBody2D

@export var speed: float = 250.0

const MARGIN: float = 32

var _upper_left: Vector2
var _lower_right: Vector2

func _ready():
	set_limits()

func _process(delta):
	var input = get_movement_input()
	position += input * delta * speed
	position = position.clamp(_upper_left, _lower_right)

func get_movement_input() -> Vector2:
	var player_vector = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	return player_vector.normalized()

func set_limits() -> void:
	var vp = get_viewport_rect()
	_lower_right = Vector2(vp.size.x - MARGIN, vp.size.y - MARGIN)
	_upper_left = Vector2(MARGIN, MARGIN)
