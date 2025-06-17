extends Node

@export var initial_state : State
@export var label : Label
var current_state : State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
#Initializes the state machine
func _process(delta):
	if current_state:
		current_state.Update(delta)
#Calls the Update function of the current state every frame. 
#Delta: time elapsed since the last frame.
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
#Calls the Update function of the current state every physics frame. 
func on_child_transition(state, new_state_name):
	if state != current_state:
		return 
	#Ignore transitions from inactive states.
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	#Ignore transitions from undefined states.
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state
