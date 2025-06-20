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

func on_action_complate() -> void:
	Transitioned.emit(self, "Idle")
