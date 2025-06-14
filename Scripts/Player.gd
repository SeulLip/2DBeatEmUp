extends CharacterBody2D

var current_input_sequence : Array[StringName] = []
var last_input_time : float = 0
var current_input_combo : StringName = ""

const SPEED = 300.0
const dash_tap_interval = 0.25
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
		
	#if not isAttacking:
		
	# Handle jump.
		#if Input.is_action_just_pressed("move_up") and is_on_floor():
			#velocity.y = jump_velocity

		#var direction := Input.get_axis("left", "right") 
		#if direction:
			#if direction > 0:
				#rotation_degrees = 0
				#scale.y = 1
			#else:
				#rotation_degrees = 180
				#scale.y = -1
			#
			#velocity.x = direction * SPEED
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
		#if Input.is_action_just_pressed("left"): 
			#if Input.is_action_just_pressed("left"): 
				#if Time.get_ticks_msec() / 1000.0 - last_left_tap_time < dash_tap_interval:
					#isDashing = true
				#else:
					#isDashing = false
					#
				#last_left_tap_time = Time.get_ticks_msec() / 1000.0
		#if Input.is_action_just_pressed("right"): 
			#if Input.is_action_just_pressed("right"): 
				#if Time.get_ticks_msec() / 1000.0 - last_right_tap_time < dash_tap_interval:
					#isDashing = true
				#else:
					#isDashing = false
					#
				#last_right_tap_time = Time.get_ticks_msec() / 1000.0
		#if isDashing:
			#velocity.x += SPEED * 25 * direction
			#isDashing = false
		#if not isAttacking: 
				#$Weapon/AnimationPlayer.play("Idle");
	#else:
		#velocity = Vector2.ZERO
	#if last_input_time + 0.5 < Time.get_ticks_msec() / 1000.0:
		#current_input_combo = ""
		#current_input_sequence = []
	#var input_changed = false
	#if current_input_combo == "":
		#
		#if Input.is_action_just_pressed("down"):
			#current_input_combo = ("down")
			#input_changed = true
		#elif Input.is_action_just_pressed("up"):
			#current_input_combo = ("up")
			#input_changed = true
		#elif Input.is_action_just_pressed("left"):
			#current_input_combo = ("left")
			#input_changed = true
		#elif Input.is_action_just_pressed("right"):
			#current_input_combo = ("right")
			#input_changed = true
		#elif Input.is_action_just_pressed("light attack"):
			#current_input_combo = ("light attack")
			#input_changed = true
		#elif Input.is_action_just_pressed("heavy attack"):
			#current_input_combo = ("heavy attack")
			#input_changed = true
	#else:
		#if Input.is_action_just_released(current_input_combo):
			#current_input_sequence.append(current_input_combo)
			#current_input_combo = ""
			#input_changed = true
		#else:
			#if Input.is_action_just_pressed("down"):
				#input_changed = true
				#match current_input_combo:
					#"left":
						#current_input_sequence.append("down-left")
						#current_input_combo = ""
					#"right":
						#current_input_sequence.append("down-right")
						#current_input_combo = ""
					#_:
						#current_input_sequence.append(current_input_combo)
						#current_input_combo = "down"
			#elif Input.is_action_just_pressed("up"):
				#input_changed = true
				#match current_input_combo:
					#"left":
						#current_input_sequence.append("up-left")
						#current_input_combo = ""
					#"right":
						#current_input_sequence.append("up-right")
						#current_input_combo = ""
					#_:
						#current_input_sequence.append(current_input_combo)
						#current_input_combo = "up"
			#elif Input.is_action_just_pressed("left"):
				#input_changed = true
				#match current_input_combo:
					#"down":
						#current_input_sequence.append("down-left")
						#current_input_combo = ""
					#"up":
						#current_input_sequence.append("up-left")
						#current_input_combo = ""
					#_:
						#current_input_sequence.append(current_input_combo)
						#current_input_combo = "up"
			#elif Input.is_action_just_pressed("right"):
				#input_changed = true
				#match current_input_combo:
					#"down":
						#current_input_sequence.append("down-right")
						#current_input_combo = ""
					#"up":
						#current_input_sequence.append("up-right")
						#current_input_combo = ""
					#_:
						#current_input_sequence.append(current_input_combo)
						#current_input_combo = "right"
			#elif Input.is_action_just_pressed("light attack"):
				#input_changed = true
				#current_input_sequence.append(current_input_combo)
				#current_input_combo = "light attack"
			#elif Input.is_action_just_pressed("heavy attack"):
				#input_changed = true
				#current_input_sequence.append(current_input_combo)
				#current_input_combo = "heavy attack"
	#if input_changed:
		#last_input_time = Time.get_ticks_msec() / 1000.0
		#for combo in combos: 
			#if current_input_sequence == combo.input:
				#$Weapon/AnimationPlayer.play(combo.attack.animation);
				#isAttacking = true
				#current_input_combo = ""
				#current_input_sequence = []
	#print("current_input_combo", current_input_combo) 
	#print("current_input_sequence", current_input_sequence)

	move_and_slide()
func jump():
		if is_on_floor():
			velocity.y = jump_velocity

func gets_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "ComboA1" or anim_name == "ComboA2" or anim_name == "KnockUp": 
		isAttacking = false;
