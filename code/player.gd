extends CharacterBody2D

# how fast george moves
var speed = 300
var health = 100

signal health_changed(new_health)


func _ready():
	add_to_group("player")


func _physics_process(delta):
	# move left and right with arrow keys
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		# slow down when not pressing anything
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

	# keep george on the screen
	if position.x < 40:
		position.x = 40
	if position.x > 1112:
		position.x = 1112


func take_damage(amount):
	health = health - amount
	if health < 0:
		health = 0
	print("george got hit! health is now: ", health)
	health_changed.emit(health)
