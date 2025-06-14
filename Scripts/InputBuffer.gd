extends Node

var buffer := []
var timer := 0.0

func _input(event):
	if event.is_pressed():
		if event is InputEventKey or event is InputEventJoypadButton:
			var direction = get_direction_vector()

			# Only record if it has a direction (↓, →, etc.)
			if direction != Vector2.ZERO:
				buffer.push_back(direction)
				print_buffer(buffer)

func _physics_process(_delta):
	timer += _delta

	if timer > 0.3:
		if $Player.is_on_floor() and Input.is_action_just_pressed("move_up"):
			$Player.jump()
			var event = buffer.pop_front()
			print('execute event %s!' % event)
			print_buffer(buffer)
			timer = 0
		elif Input.is_action_just_pressed("move_up"):
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
