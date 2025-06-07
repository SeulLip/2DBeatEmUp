extends CharacterBody2D


const SPEED = 300.0
const dash_tap_interval = 0.25
const JUMP_VELOCITY = -400.0
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_decent : float
@export var combos : Array[ComboData]
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_decent * jump_time_to_decent)) * -1.0

var last_left_tap_time = 0
var last_right_tap_time = 0
var isDashing =  false

var isAttacking = false;
var last_attack_name = null
var last_attack_count: int = 0
var ComboPoints = 2;

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gets_gravity() * delta
		
	if not isAttacking:
		
	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity

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
		if Input.is_action_just_pressed("left"): 
			if Input.is_action_just_pressed("left"): 
				if Time.get_ticks_msec() / 1000.0 - last_left_tap_time < dash_tap_interval:
					isDashing = true
				else:
					isDashing = false
					
				last_left_tap_time = Time.get_ticks_msec() / 1000.0
		if Input.is_action_just_pressed("right"): 
			if Input.is_action_just_pressed("right"): 
				if Time.get_ticks_msec() / 1000.0 - last_right_tap_time < dash_tap_interval:
					isDashing = true
				else:
					isDashing = false
					
				last_right_tap_time = Time.get_ticks_msec() / 1000.0
		if isDashing:
			velocity.x += SPEED * 25 * direction
			isDashing = false
		if not isAttacking: 
				$Weapon/AnimationPlayer.play("Idle");
	else:
		velocity = Vector2.ZERO
		
	for combo in combos: 
		if Input.is_action_just_pressed(combo.input):
			if combo.resource_name == last_attack_name:
				last_attack_count += 1
				if last_attack_count >= combo.attacks.size():
					last_attack_count = 0
			else: 
				last_attack_count = 0
			last_attack_name = combo.resource_name
			$Weapon/AnimationPlayer.play(combo.attacks[last_attack_count].animation);
			isAttacking = true
			
	if Input.is_action_just_pressed("down"):
		$Weapon/AnimationPlayer.play("KnockUp");
		isAttacking = true
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
	
func gets_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "ComboA1" or anim_name == "ComboA2" or anim_name == "KnockUp": 
		isAttacking = false;


func _on_combo_a_reset_timer_timeout() -> void:
	ComboPoints = 2;
