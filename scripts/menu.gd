extends CanvasLayer

var player_information = load("res://scenes/menu/player_informations.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_pressed() -> void:
	get_node(".").add_child(player_information.instantiate())


func _on_game_mode_pressed() -> void:
	Global.lives = 10
	Global.points = 0
	get_tree().change_scene_to_file("res://scenes/menu/playmode.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
