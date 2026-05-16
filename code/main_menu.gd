extends Control

@onready var score: Label = $Score
@onready var main_menu_buttons: VBoxContainer = $VBoxContainer
@onready var options_panel: Panel = $OptionsPanel
@onready var start_button: Button = $VBoxContainer/"Start Button"
@onready var reset_score_button: Button = $OptionsPanel/VBoxContainer/ResetHighScoreButton

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	options_panel.visible = false
	_refresh_score()
	start_button.grab_focus()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_pressed():
	main_menu_buttons.visible = false
	options_panel.visible = true
	reset_score_button.grab_focus()

func _on_exit_pressed():
	get_tree().quit()


func _on_reset_high_score_button_pressed() -> void:
	Global.save_data.high_score = 0
	Global.save_data.save()
	_refresh_score()


func _on_back_button_pressed() -> void:
	options_panel.visible = false
	main_menu_buttons.visible = true
	start_button.grab_focus()


func _refresh_score() -> void:
	var high_score = 0
	if Global.save_data != null:
		high_score = Global.save_data.high_score
	score.text = "High Score: " + str(high_score)
