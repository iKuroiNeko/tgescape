extends Spatial

onready var expressionNode = get_node("Expressions")
onready var anim = get_node("AnimationPlayer")
onready var sound = get_node("Sample")

var expression =  null
var position = Vector2()
func _ready():
	#set_fixed_process(true)
	pass

func _fixed_process(delta):
#	var pos = get_translation()
#	var cam = get_tree().get_root().get_camera()
#	#var screenPos = cam.unproject_position(pos)
#	get_node("Expre").set_pos(Vector2(g, screenPos.y + 80))
	pass
	
func expressions(expr):
	expression = expr
	if expression == "exclamation":
		expressionNode.get_node(expression).show()
		anim.play("Exclamation")
		sound.play("exp")
	elif expression == "questionMark":
		expressionNode.get_node(expression).show()
		anim.play("Exclamation")
		sound.play("exp")
	elif expression == "happy":
		expressionNode.get_node(expression).show()
		anim.play("Exclamation")
		sound.play("exp")
	elif expression == "idea":
		expressionNode.get_node(expression).show()
		anim.play("Exclamation")
		sound.play("exp")
	elif expression == "ouch":
		expressionNode.get_node(expression).show()
		anim.play("Exclamation")
		sound.play("exp")
	elif expression == "angry":
		expressionNode.get_node(expression).show()
		anim.play("Exclamation")
		sound.play("exp")
func hide_exp():
	expressionNode.get_node(expression).hide()