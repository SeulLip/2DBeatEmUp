extends State
class_name Idle

@export var player: CharacterBody2D


func Enter():
	print("Entered Idle state")
	var anim_player = player.get_node("Weapon/AnimationPlayer")
	anim_player.play("Idle")

func Exit():
	pass

func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("move_up"):
		print("Jump key pressed!")
	if Input.is_action_just_pressed("move_up"):
		print("Jump triggered!")
		Transitioned.emit(self, "Jump")
