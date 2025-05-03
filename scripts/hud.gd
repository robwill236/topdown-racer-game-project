extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.value = Global.lives


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_bar.value = Global.lives
