extends KinematicBody

onready var anim = get_node("AnimationPlayer")
onready var expr = get_node("Expression")

var hit = 0

func _ready():
	anim.play("idle")
	pass

func getHit():
	hit += 1
	expr.expressions("ouch")
	if hit == 1:
		#monster para de andar
		pass
	elif hit == 3:
		anim.play("fall")
		global.set_retratacao(5)
		global.set_compassion(-10)
		pass