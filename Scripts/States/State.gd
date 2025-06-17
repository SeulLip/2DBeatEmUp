extends Node
class_name State

signal Transitioned 

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass
#Called every frame while state is active. 
func Physics_Update(_delta: float):
	pass
#Called every physics frame while state is active. 
