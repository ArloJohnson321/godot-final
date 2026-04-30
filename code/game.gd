extends Node2D

const BASE_SPAWN_INTERVAL := 2.0
const MIN_SPAWN_INTERVAL := 0.3
const MAX_DIFFICULTY_SCORE := 300
const PASSIVE_SCORE_INTERVAL := 2.0

var score := 0
var _passive_score_timer := 0.0
var _game_over_triggered := false

@onready var player: CharacterBody2D = $CharacterBody2D
@onready var spawn_timer: Timer = $SpawnTimer
@onready var score_label: Label = $HUD/ScoreLabel
@onready var health_bar: ProgressBar = $HUD/HealthBar
@onready var game_over_panel: Panel = $HUD/GameOverPanel
@onready var final_score_label: Label = $HUD/GameOverPanel/VBoxContainer/FinalScoreLabel
@onready var pause_panel: Panel = $HUD/PausePanel

var bubble_scene := preload("res://scenes/area_2d.tscn")
var coin_scene := preload("res://scenes/coin.tscn")


func _ready() -> void:
	player.health_changed.connect(_on_health_changed)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	game_over_panel.visible = false
	pause_panel.visible = false
	spawn_timer.wait_time = BASE_SPAWN_INTERVAL
	spawn_timer.start()


func _process(delta: float) -> void:
	_passive_score_timer += delta
	if _passive_score_timer >= PASSIVE_SCORE_INTERVAL:
		_passive_score_timer = 0.0
		_add_score(1)


func _on_health_changed(new_health: int) -> void:
	health_bar.value = new_health
	if new_health <= 0 and not _game_over_triggered:
		_game_over_triggered = true
		_game_over()


func _add_score(amount: int) -> void:
	score += amount
	score_label.text = "Score: " + str(score)
	_update_difficulty()


func _update_difficulty() -> void:
	var t := clampf(float(score) / float(MAX_DIFFICULTY_SCORE), 0.0, 1.0)
	spawn_timer.wait_time = lerpf(BASE_SPAWN_INTERVAL, MIN_SPAWN_INTERVAL, t)


func _on_spawn_timer_timeout() -> void:
	_spawn_item()


func _spawn_item() -> void:
	var item: Area2D
	if randf() < 0.6:
		item = bubble_scene.instantiate()
	else:
		item = coin_scene.instantiate()
		item.coin_collected.connect(_on_coin_collected)

	var x := randf_range(50.0, 1100.0)
	item.position = Vector2(x, -50.0)

	var speed_mult := 1.0 + float(score) / 150.0
	item.fall_speed *= speed_mult

	add_child(item)


func _on_coin_collected(value: int) -> void:
	_add_score(value)


func _game_over() -> void:
	spawn_timer.stop()
	final_score_label.text = "Score: " + str(score)
	game_over_panel.visible = true
	get_tree().paused = true


func _on_pause_button_pressed() -> void:
	if _game_over_triggered:
		return
	get_tree().paused = !get_tree().paused
	pause_panel.visible = get_tree().paused


func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_panel.visible = false


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/control.tscn")
