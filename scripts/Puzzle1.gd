extends Node2D

onready var frame = get_node("Frame")
#onready var tie = get_node("Panel/TIE")

func _ready():
	frame.show()
	global.set_canHit(false)
	pass
	
