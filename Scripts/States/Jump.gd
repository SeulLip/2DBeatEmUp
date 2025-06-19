extends State
class_name Jump

@export var player: CharacterBody2D

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_decent : float

var frame_counter := 0

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_decent * jump_time_to_decent)) * -1.0


func Enter():
	print("Entered Jump state")
	frame_counter = 0

func Physics_Update(delta):
	frame_counter += 1
	player.velocity.y += gets_gravity() * delta
	player.move_and_slide()
	if frame_counter == 3:
		$"../Walk".Update_Velocity()
		jump()
	elif frame_counter > 3:

		if player.is_on_floor():
				Transitioned.emit(self, "Idle")
	if Input.is_action_just_pressed("light_attack"):
		print("j_Light triggered!")
		Transitioned.emit(self, "j_Light")
 
func jump():
		if player.is_on_floor():
			player.velocity.y = jump_velocity

func gets_gravity() -> float:
	return jump_gravity if player.velocity.y < 0.0 else fall_gravity
