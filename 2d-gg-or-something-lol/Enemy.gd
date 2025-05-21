extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")
var speed: float = 300
var gravity = 15

@export_range(-1, 1) var direction: int = 1

func _ready() -> void:
	if direction == 0:
		direction = 1
		$DummySprite.flip_h = false if direction == 1 else true

func _physics_process(delta: float) -> void:
	if direction == 1 and ($Rightray.is_colliding() or $Rightwallray.is_colliding()):
		$DummySprite.flip_h = true
		direction = -1
	if direction == -1 and ($Leftray.is_colliding() or $Leftwallray.is_colliding()):
		$DummySprite.flip_h = false
		direction = 1 
	
	velocity.x = lerp(velocity.x, direction * speed, 10*delta)
	velocity.y += gravity
	move_and_slide()
	
	
