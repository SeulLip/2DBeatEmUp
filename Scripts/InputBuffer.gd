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
		if event is InputEventKey:
			var key_name := OS.get_keycode_string(event.keycode)
			p.push_back(key_name)
		elif event is InputEventJoypadButton:
			var button_name := "Button " + str(event.button_index)
			p.push_back(button_name)
	
	# Convert to string and update label
	var buffer_text := "[" + ", ".join(p) + "]"
	#print(buffer_text)
	$CanvasLayer/BufferLabel.text = buffer_text
