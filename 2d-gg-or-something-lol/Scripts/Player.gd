extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var isAttacking = false;
var ComboPoints = 2;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not isAttacking:
		
	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("left", "right") 
		if direction:
			if direction > 0:
				rotation_degrees = 0
				scale.y = 1
			else:
				rotation_degrees = 180
				scale.y = -1
			
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if isAttacking == false: 
				$Weapon/AnimationPlayer.play("Idle");
	else:
		velocity = Vector2.ZERO
	if Input.is_action_just_pressed("attack") and ComboPoints == 2:
		$ComboAResetTimer.start();
		$Weapon/AnimationPlayer.play("ComboA1");
		ComboPoints = ComboPoints -1;
		isAttacking = true;  
	elif Input.is_action_just_pressed("attack") and ComboPoints == 1:
		$ComboAResetTimer.start();
		$Weapon/AnimationPlayer.play("ComboA2");
		ComboPoints = ComboPoints -1;
		isAttacking = true;  
	move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "ComboA1" or "ComboA2": 
		isAttacking = false;


func _on_combo_a_reset_timer_timeout() -> void:
	ComboPoints = 2;
