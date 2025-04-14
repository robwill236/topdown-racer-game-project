extends Control

#var player_information = load("res://scene/player_informations.tscn")
@onready var player = $MarginContainer/VBoxContainer/Player


func _ready() -> void:
	get_tree().paused = false

func _on_player_pressed() -> void:
	#get_node(".").add_child(player_information.instantiate())
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()


func resume_pressed() -> void:
	prints("welcome workimg")
	get_tree().paused = false
