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
	if timer > 1:
		var event = buffer.pop_front()
		print('execute event %s!'%event)
		print_buffer(buffer)
		timer = 0


func print_buffer(b:Array):
	var p := []
	for event in b:
		if event is InputEventKey:
			p.push_back(event.keycode)
		if event is InputEventJoypadButton:
			p.push_back(event.button_index)
	print(p)
