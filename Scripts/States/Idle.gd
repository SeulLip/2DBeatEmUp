extends State
class_name Idle

@export var player: CharacterBody2D


func Enter():
	var anim_player = player.get_node("Weapon/AnimationPlayer")
	anim_player.play("Idle")
