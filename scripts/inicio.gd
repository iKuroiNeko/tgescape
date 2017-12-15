extends Node2D

onready var tie = get_node("Panel/TIE")
onready var panel = get_node("Panel")


func _ready():
	panel.show()
	tie.buff_text("Digite seu nome:\n", 0.005)
	
	tie.set_state(tie.STATE_OUTPUT)
	tie.buff_input()
	


func _on_TIE_input_enter( input ):
	global.set_playerName(input)
	Globals.set("playerName",input)
	Transition.fade_to("Game.tscn")
	print(str(Globals.get("playerName")))
