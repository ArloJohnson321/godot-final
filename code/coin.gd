extends Area2D

var fall_speed = 250
var score_value = 10

signal coin_collected(value)


func _ready():
	body_entered.connect(_on_body_entered)


func _process(delta):
	position.y = position.y + (fall_speed * delta)
	if position.y > 1300:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		coin_collected.emit(score_value)
		queue_free()
