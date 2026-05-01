extends CharacterBody2D

# how fast george moves
var speed = 600
var health = 100

signal health_changed(new_health)


func _ready():
	add_to_group("player")


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

	if position.x < 40:
		position.x = 40
	if position.x > 1112:
		position.x = 1112


func take_damage(amount):
	health = health - amount
	if health < 0:
		health = 0
	health_changed.emit(health)
