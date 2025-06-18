extends State
class_name Idle

@export var player: CharacterBody2D


func Enter():
	print("Entered Idle state")
	player.velocity = Vector2.ZERO
	var anim_player = player.get_node("Weapon/AnimationPlayer")
	anim_player.play("Idle")

func Exit():
	pass

func Physics_Update(_delta: float):
	var direction := Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("move_up"):
		print("Jump triggered!")
		Transitioned.emit(self, "Jump")
	if player.is_on_floor() and abs(direction) > 0.000001:
		print("Walk triggered!")
		Transitioned.emit(self, "Walk")
