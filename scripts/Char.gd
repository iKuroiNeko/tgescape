extends RigidBody

onready var char = get_node("Armature/Skeleton")
onready var anim = get_node("AnimationPlayer")

#var canMove = true
var move = false
var isAttacking = false



func _ready():
	set_process_input(true)
	set_fixed_process(true)
	

func _input(event):
	if event.is_action_released("ui_up"):
		move = false
	if event.is_action_released("ui_down"):
		move = false
	if event.is_action_released("ui_left"):
		move = false
	if event.is_action_released("ui_right"):
		move = false
	if event.is_action_pressed("hitButton") and global.get_canHit():
		playHit()
		
func _fixed_process(delta):
	
	###########################################################
	###### MOVE
	if Input.is_action_pressed("ui_up") and global.canMove:
		move = true
		
		char.set_rotation(Vector3(0,deg2rad(180),0))
		set_linear_velocity(Vector3(0,get_linear_velocity().y,-25))
	if Input.is_action_pressed("ui_down") and global.canMove:
		move = true
		char.set_rotation(Vector3(0,deg2rad(0),0))
		set_linear_velocity(Vector3(0,get_linear_velocity().y,25))
	if Input.is_action_pressed("ui_left") and global.canMove:
		move = true
		char.set_rotation(Vector3(0,deg2rad(-90),0))
		set_linear_velocity(Vector3(-25,get_linear_velocity().y,0))
	if Input.is_action_pressed("ui_right") and global.canMove:
		move = true
		char.set_rotation(Vector3(0,deg2rad(90),0))
		set_linear_velocity(Vector3(25,get_linear_velocity().y,0))
	if move == false:
		set_linear_velocity(Vector3(0,get_linear_velocity().y,0))

	###########################################################
	###### ANIMATION
	
	

	if move == false and isAttacking == false:
		if anim.get_current_animation() != "idle":
			anim.play("idle")
		
	elif move and isAttacking == false:
		if anim.get_current_animation() != "walk":
			anim.play("walk")


func playHit():
	isAttacking = true
	global.canMove = false
	anim.play("hit")
	global.set_canHit(false)
func notAttack():
	global.canMove = true
	isAttacking = false
	global.set_canHit(true)