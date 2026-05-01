extends Node2D

var score = 0
var game_over = false
var time_since_last_score = 0

var spawn_time = 2.0  

@onready var player = $CharacterBody2D
@onready var spawn_timer = $SpawnTimer
@onready var score_label = $HUD/ScoreLabel
@onready var health_bar = $HUD/HealthBar
@onready var game_over_panel = $HUD/GameOverPanel
@onready var final_score_label = $HUD/GameOverPanel/VBoxContainer/FinalScoreLabel
@onready var pause_panel = $HUD/PausePanel

var bubble_scene = preload("res://scenes/area_2d.tscn")
var coin_scene = preload("res://scenes/coin.tscn")


func _ready():
	player.health_changed.connect(_on_health_changed)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	game_over_panel.visible = false
	pause_panel.visible = false
	spawn_timer.wait_time = spawn_time
	spawn_timer.start()


func _process(delta):
	if game_over == true:
		return
	time_since_last_score = time_since_last_score + delta
	if time_since_last_score >= 2.0:
		time_since_last_score = 0
		add_score(1)


func _on_health_changed(new_health):
	health_bar.value = new_health
	if new_health <= 0 and game_over == false:
		game_over = true
		do_game_over()


func add_score(amount):
	score = score + amount
	score_label.text = "Score: " + str(score)
	update_difficulty()


func update_difficulty():
	if score >= 300:
		spawn_timer.wait_time = 0.3
	else:
		var time = float(score) / 300.0
		spawn_timer.wait_time = .75


func _on_spawn_timer_timeout():
	spawn_item()


func spawn_item():
	var item
	var roll = randf()
	if roll < 0.95:
		item = bubble_scene.instantiate()
	else:
		item = coin_scene.instantiate()
		item.coin_collected.connect(add_score)

	var x = randf_range(50, 1100)
	item.position = Vector2(x, -50)

	var speed_mult = 1.0 + (float(score) / 150.0)
	item.fall_speed = item.fall_speed * speed_mult

	add_child(item)


func do_game_over():
	spawn_timer.stop()
	final_score_label.text = "Score: " + str(score)
	game_over_panel.visible = true
	get_tree().paused = true


func _on_pause_button_pressed():
	if game_over == true:
		return
	get_tree().paused = !get_tree().paused
	pause_panel.visible = get_tree().paused


func _on_resume_pressed():
	get_tree().paused = false
	pause_panel.visible = false


func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/control.tscn")
