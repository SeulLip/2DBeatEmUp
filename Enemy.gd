extends RigidBody2D
@export var animation: AnimationPlayer
@export var weight: float = 1
func _ready() -> void:
	animation.play("Idle");


func _on_enemy_hurtbox_on_hit(player: CharacterBody2D, attackdata: AttackData) -> void:
	
		add_knockup_and_knockback(player, attackdata)
		knockup_animation()
	

func _on_animation_enemy_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hit":
		animation.play("RESET");
	elif anim_name == "RESET":
		animation.play("Idle");


func add_knockup_and_knockback(player: CharacterBody2D, attack: AttackData):
	var velocity = Vector2(attack.knockback, attack.knockup)
	velocity.x *= sign( $"..".global_position.x - player.global_position.x)
	linear_velocity.x += velocity.x
	linear_velocity.y -= velocity.y
	
func knockback_animation():
	animation.play("Hit");
	HitStopManager.hit_stop_light() 
	
func knockup_animation():
	animation.play("Hit");
	HitStopManager.hit_stop_medium() 
