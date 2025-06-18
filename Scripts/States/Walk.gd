extends State
class_name Walk

@export var player: CharacterBody2D
@onready var jump_state = $"../Jump"

@export var walk_speed: float

func Enter():
	print("Entered Walk state")


func Exit():
	pass

func Physics_Update(delta: float):
	var gravity = jump_state.fall_gravity
	player.velocity.y += gravity * delta
	
	Update_Velocity()
	if player.velocity == Vector2.ZERO:
		Transitioned.emit(self, "Idle")
	if Input.is_action_just_pressed("move_up"):
		print("Jump triggered!")
		Transitioned.emit(self, "Jump")
	if Input.is_action_just_pressed("move_down"):
		print("Crouch triggered!")
		Transitioned.emit(self, "Crouch")
	player.move_and_slide()

func Update_Velocity():
	var direction := Input.get_axis("move_left", "move_right")
	if abs(direction) < 0.000001:
		player.velocity = Vector2.ZERO
	else:
		if direction > 0:
			player.rotation_degrees = 0
			player.scale.y = 1
		else:
			player.rotation_degrees = 180
			player.scale.y = -1
		
		player.velocity.x = direction * walk_speed
