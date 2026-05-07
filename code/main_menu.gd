extends Control

@onready var score: Label = $Score

func _ready() -> void:
	pass

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_pressed():
	pass

func _on_exit_pressed():
	get_tree().quit()



	


func _on_ready() -> void:
	var high_score = Global.save_data.high_score
	score.text = "High Score: " + str(high_score)
	Global.save_data.high_score = 10
	Global.save_data.save()
