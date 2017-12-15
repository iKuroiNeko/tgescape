extends KinematicBody

onready var anim = get_node("AnimationPlayer")

var posAtual
var destino
var move = false
var myDelta


func _ready():
	anim.play("idle")
		
func _fixed_process(delta):	
	pass
	
func walk():
	set_rotation_deg(Vector3(180, 0, 180))
	

