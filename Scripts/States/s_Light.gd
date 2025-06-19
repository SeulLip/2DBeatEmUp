extends State
class_name s_Light

@export var player: CharacterBody2D
@onready var jump_state = $"../Jump"

func Enter():
	print("Entered s_Light state")
	player.velocity = Vector2.ZERO
	var anim_player = player.get_node("Weapon/AnimationPlayer")
	anim_player.play("s_Light")

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
