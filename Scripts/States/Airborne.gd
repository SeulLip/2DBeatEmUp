extends State
class_name Airborne
@export var player: CharacterBody2D





func Enter():
	print("Entered Airborne state")

func Physics_Update(delta):
	player.velocity.y += gets_gravity() * delta
	player.move_and_slide()

	if player.is_on_floor():
		Transitioned.emit(self, "Idle")
		return
	if $"../../InputBuffer".has_lightattack_input():
		print("j_Light triggered!")
		Transitioned.emit(self, "j_Light")
 

func gets_gravity() -> float:
	var jump_gravity = $"../Jump".jump_gravity
	var fall_gravity = $"../Jump".fall_gravity
	return jump_gravity if player.velocity.y < 0.0 else fall_gravity
