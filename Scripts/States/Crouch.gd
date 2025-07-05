extends State
class_name Crouch
@export var player: CharacterBody2D
@onready var jump_state = $"../Jump"

func Enter():
	print("Entered Crouch state")
	player.velocity = Vector2.ZERO
	var anim_player = player.get_node("Weapon/AnimationPlayer")
	anim_player.play("Crouch")

func Exit():
	pass

func Physics_Update(delta: float):
	var gravity = jump_state.fall_gravity
	player.velocity.y += gravity * delta
	player.move_and_slide()

	if $"../../InputBuffer".has_jump_input():
		print("PreJump triggered!")
		Transitioned.emit(self, "PreJump")
	if Input.is_action_just_released("move_down"):
		Transitioned.emit(self, "Idle")
