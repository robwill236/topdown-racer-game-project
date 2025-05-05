extends CanvasLayer

@onready var highest_score: Label = $MarginContainer/VBoxContainer/Level1/highest_score
@onready var current_score: Label = $MarginContainer/VBoxContainer/Level2/current_score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	highest_score.text = str(Global.score3)
	current_score.text = str(Global.current3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	Global.lives = 10
	Global.points = 0
	get_tree().reload_current_scene()


func _on_change_pressed() -> void:
	Global.lives = 10
	Global.points = 0
	get_tree().change_scene_to_file("res://scenes/menu/playmode.tscn")


func _on_quit_pressed() -> void:
	Global.points = 0
	get_tree().quit()
