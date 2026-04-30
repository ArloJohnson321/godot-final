extends CharacterBody2D

const SPEED = 300.0
const SCREEN_LEFT = 40.0
const SCREEN_RIGHT = 1112.0

var health := 100
signal health_changed(new_health: int)


func _ready() -> void:
	add_to_group("player")


func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	position.x = clamp(position.x, SCREEN_LEFT, SCREEN_RIGHT)


func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)
	health_changed.emit(health)
