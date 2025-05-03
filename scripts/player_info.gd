extends CanvasLayer

@onready var player_name: LineEdit = $MarginContainer/VBoxContainer/Name/PlayerName/LineEdit
@onready var score_1: Label = $MarginContainer/VBoxContainer/Level1/score1
@onready var score_2: Label = $MarginContainer/VBoxContainer/Level2/score2
@onready var score_3: Label = $MarginContainer/VBoxContainer/Level3/score3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_1.text = str(Global.score1)
	score_2.text = str(Global.score2)
	score_3.text = str(Global.score3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_node(".").queue_free() 


func _on_save_pressed() -> void:
	var config = ConfigFile.new()
	config.set_value("Information", "player_name", player_name.text)
	config.set_value("Highest Score", "level_1", score_1.text)
	config.set_value("Highest Score", "level_2", score_2.text)
	config.set_value("Highest Score", "level_3", score_3.text)
	config.save("user://player.cfg")


func _on_load_pressed() -> void:
	var config = ConfigFile.new()
	var result = config.load("user://player.cfg")
	
	if result == OK:
		player_name.text = config.get_value("Information", "player_name")
		score_1.text = config.get_value("Highest Score", "level_1")
		score_2.text = config.get_value("Highest Score", "level_2")
		score_3.text = config.get_value("Highest Score", "level_3")
	else:
		printerr("Error while loading file!!")


func _on_back_pressed() -> void:
	get_node(".").queue_free() 
