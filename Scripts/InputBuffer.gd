extends Node

var buffer := []
var timer := 0.0

@export var player: CharacterBody2D
@onready var state_machine = $"../StateMachine"

var held_directions := {
	"move_up": false,
	"move_down": false,
	"move_left": false,
	"move_right": false
}

func _input(event):
	# Only care about keys or buttons
	if event is InputEventKey or event is InputEventJoypadButton:
		for action in held_directions.keys():
			if InputMap.action_has_event(action, event):
				# Update held state
				held_directions[action] = event.pressed
func has_lightattack_input():
	return Input.is_action_just_pressed("light_attack")
	
func has_jump_input():
	return Input.is_action_pressed("move_up")
	#if not Input.is_action_pressed("move_up"):
		#return false
	#if player.velocity.y > 0.0001:
		#if not buffer.is_empty():
			#var first_in_buffer = buffer[0]
			#if first_in_buffer == Vector2(0, -1) or Vector2(1, -1) or Vector2(-1, -1):
				#var event = buffer.pop_front()
				#return true 
func has_crouch_input():
	return Input.is_action_pressed("move_down")

func get_current_direction() -> Vector2:
	var x := int(held_directions["move_right"]) - int(held_directions["move_left"])
	var y := int(held_directions["move_down"]) - int(held_directions["move_up"])
	return Vector2(x, y)


var frame_counter := 0

func _physics_process(_delta):
	frame_counter += 1

	if frame_counter % 17:
		var new_direction := get_current_direction()
		if buffer.is_empty() or buffer.back() != new_direction:
			if new_direction != Vector2.ZERO:
				buffer.push_back(new_direction)
				print_buffer(buffer)
			else:
				buffer.clear()

func print_buffer(b: Array):
	var symbols := []

	for dir in b:
		var symbol := ""

		match dir:
			Vector2(0, -1): symbol = "↑"
			Vector2(0, 1): symbol = "↓"
			Vector2(-1, 0): symbol = "←"
			Vector2(1, 0): symbol = "→"
			Vector2(1, 1): symbol = "↘"
			Vector2(-1, 1): symbol = "↙"
			Vector2(1, -1): symbol = "↗"
			Vector2(-1, -1): symbol = "↖"

		symbols.push_back(symbol)

	$CanvasLayer/BufferLabel.text = "[" + ", ".join(symbols) + "]"

func get_direction_vector() -> Vector2:
	var x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return Vector2(x, y)
