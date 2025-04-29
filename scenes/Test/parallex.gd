extends ParallaxBackground
@export var scroll_speed := Vector2(0, 50) # scrolls down automatically


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_offset += scroll_speed * delta
