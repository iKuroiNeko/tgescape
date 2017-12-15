extends RigidBody
#extends KinematicBody

onready var anim = get_node("AnimationPlayer")
onready var timer = get_node("Timer")
onready var expr = get_node("Expression")

var hit = 0
var vel = 6
var moving = false
var rot

func _ready():
	randomize()
	set_fixed_process(true)
	timer.start()
	rot = floor(rand_range(0,4))
	

func _fixed_process(delta):
	
	if hit == 0:
		moving = true
		
		#andar pra esquerda
		if rot == 0:
			set_rotation(Vector3(0,deg2rad(-90),0))
			global_translate(Vector3(delta * vel * -1,0,0))
		#andar pra direita
		elif rot == 1:
			set_rotation(Vector3(0,deg2rad(90),0))
			global_translate(Vector3(delta * vel,0,0))
		#andar pra cima
		elif rot == 2:
			set_rotation(Vector3(0,deg2rad(0),0))
			global_translate(Vector3(0,0, delta * vel))
		#andar pra baixo
		elif rot == 3:
			set_rotation(Vector3(0,deg2rad(180),0))
			global_translate(Vector3(0,0,delta * vel * -1))
		if moving:
			if anim.get_current_animation() != "walk":
				anim.play("walk")
	if hit == 1:
		anim.stop()
		
    

func getHit():
	hit += 1
	expr.expressions("ouch")
	apply_impulse(Vector3(0,0,0),Vector3(0,5,0))
	if hit == 3:
		anim.play("fall")
		global.set_retratacao(5)
		global.set_compassion(-10)
		
		pass


func _on_Timer_timeout():
	rot = floor(rand_range(0,4))
	
	timer.start()