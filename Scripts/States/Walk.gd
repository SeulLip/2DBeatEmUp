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
	if $"../../InputBuffer".has_jump_input():
		print("PreJump triggered!")
		Transitioned.emit(self, "PreJump")
	if $"../../InputBuffer".has_crouch_input():
		print("Crouch triggered!")
		Transitioned.emit(self, "Crouch")
	if $"../../InputBuffer".has_lightattack_input():
		print("s_Light triggered!")
		Transitioned.emit(self, "s_Light")
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
