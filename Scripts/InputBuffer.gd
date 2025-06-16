extends Node

var buffer := []
var timer := 0.0

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



func get_current_direction() -> Vector2:
	var x := int(held_directions["move_right"]) - int(held_directions["move_left"])
	var y := int(held_directions["move_down"]) - int(held_directions["move_up"])
	return Vector2(x, y)


var frame_counter := 0

func _physics_process(_delta):
	frame_counter += 1

	if frame_counter % 16:
		var new_direction := get_current_direction()
		if buffer.is_empty() or buffer.back() != new_direction:
			if new_direction != Vector2.ZERO:
				buffer.push_back(new_direction)
				print_buffer(buffer)
			else:
				buffer.clear()

		if Input.is_action_pressed("move_up") and $Player.is_on_floor():
			if not buffer.is_empty():
				var first_in_buffer = buffer[0]
				if first_in_buffer == Vector2(0, -1):
					var event = buffer.pop_front()
					$Player.jump()
					print("Execute event %s!" % event)
					print_buffer(buffer)



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
