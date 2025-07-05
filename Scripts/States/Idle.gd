extends State
class_name Idle

@export var player: CharacterBody2D
@onready var jump_state = $"../Jump"

func Enter():
	print("Entered Idle state")
	player.velocity = Vector2.ZERO
	var anim_player = player.get_node("Weapon/AnimationPlayer")
	anim_player.play("Idle")

func Exit():
	pass

func Physics_Update(delta: float):
	var gravity = jump_state.fall_gravity
	player.velocity.y += gravity * delta
	player.move_and_slide()
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if $"../../InputBuffer".has_jump_input():
		print("PreJump triggered!")
		Transitioned.emit(self, "PreJump")
	if player.is_on_floor() and abs(direction) > 0.000001:
		print("Walk triggered!")
		Transitioned.emit(self, "Walk")
	if $"../../InputBuffer".has_crouch_input():
		print("Crouch triggered!")
		Transitioned.emit(self, "Crouch")
	if $"../../InputBuffer".has_lightattack_input():
		print("s_Light triggered!")
		Transitioned.emit(self, "s_Light")
