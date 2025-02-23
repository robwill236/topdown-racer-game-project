extends CharacterBody2D

@export var speed: float = 250.0

func _process(delta):
	var input = get_movement_input()
	position += input * delta * speed

func get_movement_input() -> Vector2:
	var player_vector = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	return player_vector.normalized()
