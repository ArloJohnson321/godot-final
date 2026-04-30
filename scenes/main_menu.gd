extends Control


func _on_start_pressed():
	# go to the game
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_pressed():
	pass # maybe add options later idk


func _on_exit_pressed():
	get_tree().quit()
