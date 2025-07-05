extends State
class_name PreJump

var frame_counter := 0

func Enter():
	print("Entered PreJump state")
	frame_counter = 0
	
func Physics_Update(_delta):
	frame_counter += 1

	if frame_counter == 3:
		$"../Walk".Update_Velocity()
		Transitioned.emit(self, "Jump")
