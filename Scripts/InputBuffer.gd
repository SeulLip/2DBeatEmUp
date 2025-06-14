extends Node

var buffer :=[]
var timer := 0.0

func _input(event):
	if event.is_pressed():
		if event is InputEventKey or event is InputEventJoypadButton:
			buffer.push_back(event)
			print_buffer(buffer)



func _physics_process(_delta):
	timer += _delta
	if timer > 0.3:
		if $Player.is_on_floor() and Input.is_action_just_pressed("move_up"):
			$Player.jump()
			var event = buffer.pop_front()
			#$CanvasLayer/BufferLabel.text = str(buffer)
			print('execute event %s!'%event)
			print_buffer(buffer)
			timer = 0
		elif Input.is_action_just_pressed("move_up"):
			buffer.clear()

func print_buffer(b: Array):
	var p := []
	for event in b:
		var symbol: String = ""

		if event is InputEventKey or event is InputEventJoypadButton:
			if InputMap.action_has_event("move_up", event):
				symbol = "↑"
			elif InputMap.action_has_event("move_down", event):
				symbol = "↓"
			elif InputMap.action_has_event("move_left", event):
				symbol = "←"
			elif InputMap.action_has_event("move_right", event):
				symbol = "→"

		# If no directional symbol matched, fall back to raw input
		if symbol == "":
			if event is InputEventKey:
				symbol = OS.get_keycode_string(event.keycode)
			elif event is InputEventJoypadButton:
				symbol = "Button " + str(event.button_index)

		p.push_back(symbol)

	var buffer_text := "[" + ", ".join(p) + "]"
	$CanvasLayer/BufferLabel.text = buffer_text
