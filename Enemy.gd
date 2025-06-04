extends RigidBody2D
@export var animation: AnimationPlayer
func _ready() -> void:
	animation.play("Idle");

func _on_enemy_hurtbox_on_hit(player: CharacterBody2D) -> void:
	add_knockback(player)
	knockback_animation()
	

func _on_animation_enemy_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hit":
		animation.play("RESET");
	elif anim_name == "RESET":
		animation.play("Idle");

func add_knockback(player: CharacterBody2D):
	var knockback_velocity = 150
	knockback_velocity *= sign( $"..".global_position.x - player.global_position.x)
	linear_velocity.x += knockback_velocity
	
func add_knockup(player: CharacterBody2D):
	var knockback_velocity = 200
	knockback_velocity *= sign( $"..".global_position.x - player.global_position.x)
	linear_velocity.y += knockback_velocity
	
func knockback_animation():
	animation.play("Hit");
	HitStopManager.hit_stop_light() 
	
func knockup_animation():
	animation.play("Hit");
	HitStopManager.hit_stop_medium() 
