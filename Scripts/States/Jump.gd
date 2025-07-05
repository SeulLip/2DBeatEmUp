extends State
class_name Jump
@export var player: CharacterBody2D

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_decent : float
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_decent * jump_time_to_decent)) * -1.0

func Enter():
	print("Entered Jump state")
	player.velocity.y = jump_velocity
func Physics_Update(_delta):
	Transitioned.emit(self, "Airborne")
