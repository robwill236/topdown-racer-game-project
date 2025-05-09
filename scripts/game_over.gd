extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	Global.lives = 10
	Global.points = 0
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	Global.points = 0
	get_tree().quit()


func _on_change_pressed() -> void:
	Global.lives = 10
	Global.points = 0
	get_tree().change_scene_to_file("res://scenes/menu/playmode.tscn")
