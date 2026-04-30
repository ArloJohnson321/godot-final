extends Area2D

# how fast the bubble falls
var fall_speed = 250
# how much damage it does
var damage = 25


func _ready():
	# connect so it knows when george touches it
	body_entered.connect(_on_body_entered)


func _process(delta):
	# make it fall down
	position.y = position.y + (fall_speed * delta)
	# delete it if it goes off the bottom of the screen
	if position.y > 1300:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		print("bubble hit george!")
		body.take_damage(damage)
		queue_free()
