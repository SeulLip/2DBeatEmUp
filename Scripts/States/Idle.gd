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
	if Input.is_action_just_pressed("move_up"):
		print("Jump triggered!")
		Transitioned.emit(self, "Jump")
	if player.is_on_floor() and abs(direction) > 0.000001:
		print("Walk triggered!")
		Transitioned.emit(self, "Walk")
	if Input.is_action_just_pressed("move_down"):
		print("Crouch triggered!")
		Transitioned.emit(self, "Crouch")
	elif Input.is_action_pressed("move_down"):
		print("Crouch triggered!")
		Transitioned.emit(self, "Crouch")
	if Input.is_action_just_pressed("light_attack"):
		print("s_Light triggered!")
		Transitioned.emit(self, "s_Light")
