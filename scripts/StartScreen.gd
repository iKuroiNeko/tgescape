extends Node

onready var timer = get_node("Timer")


func _ready():
	set_process_input(true)
	global.set_charPos(Vector3(-4.668701,-3.47173,-7.739218))
	
func _input(event):
	if event.is_action_pressed("enter") or event.is_action_pressed("actionButton"):
		Transition.fade_to("inicio.tscn")
