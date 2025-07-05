extends State
class_name j_Light

@export var player: CharacterBody2D
@onready var jump_state = $"../Jump"

func Enter():
	print("Entered j_Light state")
	var anim_player = player.get_node("Weapon/AnimationPlayer")
	anim_player.play("j_Light")

func Exit():
	pass

func Physics_Update(delta: float):
	var gravity = jump_state.fall_gravity
	player.velocity.y += gravity * delta
	player.move_and_slide()
	if player.is_on_floor():
		Transitioned.emit(self, "Idle")
func on_action_complate() -> void:
	Transitioned.emit(self, "Airborne")
