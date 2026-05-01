extends Area2D


var fall_speed = 250
var damage = 25


func _ready():
	body_entered.connect(_on_body_entered)


func _process(delta):
	position.y = position.y + (fall_speed * delta)
	if position.y > 1300:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
