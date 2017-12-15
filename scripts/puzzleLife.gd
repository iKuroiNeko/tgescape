extends Control

onready var tie = get_node("Panel/TIE")
onready var panel = get_node("Panel")
onready var msg = get_node("../../Message")
onready var option = get_node("OptionPanel")


var weapon = null
var resolvido
var puzzleAberto = false
var buffEnd = false
var temPergunta
var array1 = global.get_itemArray()
var move = false
var lifeResolvido = false
var pudimResolvido = false


var seconds = 0
var elapsed = 0
var time_now = 0
var time_start = OS.get_unix_time()
		
func _ready():
	
	set_process_input(true)
	resolvido = global.get_puzzle4Res()

func _input(event):
	if event.is_action_pressed("cancelButton") and puzzleAberto:
		closePuzzle()
		puzzleAberto = false
	if event.is_action_pressed("actionButton") and puzzleAberto and buffEnd:
		closePuzzle()
		puzzleAberto = false
		

func openPuzzle():
	if global.get_hanagaSalaVidro() or global.get_puzzleLife() == false:
		self.show()
		puzzleAberto = true
		dialog()
		global.set_canMove(false)
#		time_start = OS.get_unix_time()
#		set_process(true)
		global.set_canHit(false)
	else: return
	
func closePuzzle():
	self.hide()
	puzzleAberto = false
	tie.reset()
	global.set_canMove(true)
#	set_process(false)
#	global.set_puzzleTime(elapsed)
	global.set_canHit(true)

func _on_TIE_buff_end():
	buffEnd = true

func dialog():
	buffEnd = false
	tie.reset()
	tie.buff_text("Preciso de uma senha aqui. (Confirmar: Enter, Cancelar X)\n", 0.005)
	tie.buff_input()
	tie.set_state(tie.STATE_OUTPUT)

func _on_TIE_input_enter( input ):
	tie.reset()
	if global.get_hanagaSalaVidro() == false and global.get_puzzleLife() == false:
		if input.to_upper() == "LIFE":
			lifeResolvido = true
#			global.set_puzzle4Res(resolvido)
			if global.get_hanagaSala1() == false:
				global.set_puzzle4Res(true)
			global.set_puzzleLife(true)
			tie.buff_text("A porta de vidro se abriu! ", 0.005)
			buffEnd = true
			global.set_portaVidroFechada(false)
			get_parent().get_parent().get_node("AnimationPlayer").play("glassDoor")
			for i in range(0, array1.size()):
				if array1[i] == "Papel Colorido":
					array1.remove(i)
					print("free item")
					print(i)
					Inventory.updateItems()
					break
			if global.get_hanagaSala1():
				set_process(true)
				
		elif input.to_upper() == "PUDIM":
			tie.buff_text("Nada aconteceu... Mas talvez eu precise dessa senha mais tarde.",0.005)
		else:
			tie.buff_text(".....", 0.005)
			buffEnd = true
		 tie.set_state(tie.STATE_OUTPUT)	
	if global.get_hanagaSalaVidro():
		if input.to_upper() == "PUDIM":
			tie.buff_text("A porta de vidro se abriu! ", 0.005)
			buffEnd = true
			pudimResolvido = true
			global.set_puzzlePudim(true)
			global.set_puzzle4Res(true)
			global.set_portaVidroFechada(false)
			get_parent().get_parent().get_node("AnimationPlayer").play("glassDoor")
			for i in range(0, array1.size()):
				if array1[i] == "Papel com Frase":
					array1.remove(i)
					print("free item")
					print(i)
					Inventory.updateItems()
					break
			if global.get_hanagaSala1():
				set_process(true)
			global.set_compassion(5)
			global.set_assertividade(5)
			
			if global.get_hanagaSala1():
				global.set_hanagaSala2(true)
				if global.get_saidaTrancado() == false:
					global.set_hanagaSaida(true)
				elif global.get_corredor4Trancado() == false:
					global.set_hanagaSala3(true)
				elif global.get_corredor3Trancado() == false:
					global.set_hanagaSala2(true)
			if global.get_feiSala1():
				global.set_feiSala1(false)
				if global.get_saidaTrancado() == false:
					global.set_feiSaida(true)
				elif global.get_corredor4Trancado() == false:
					global.set_feiSala3(true)
				elif global.get_corredor3Trancado() == false:
					global.set_feiSala2(true)

		else: 
			tie.buff_text(".....", 0.005)
			buffEnd = true
			
onready var hanagaFollow = get_parent().get_parent().get_node("Hanaga/PathFollow")
onready var hanaga = get_parent().get_parent().get_node("Hanaga/PathFollow/Hanaga")


func _process(delta):
#	seconds = 0
#	elapsed = 0
#	time_now = OS.get_unix_time()
#	elapsed = time_now - time_start
#	seconds = elapsed
#	print("elapsed : ", seconds)
#	
#	
	hanagaFollow.set_unit_offset( hanagaFollow.get_unit_offset() + 0.1 *delta)
	move = true
	if global.get_hanagaSalaVidro() == false:
		if move == false:
			if hanaga.get_node("AnimationPlayer").get_current_animation() !="idle":
				hanaga.get_node("AnimationPlayer").play("idle")
		
		elif move:
			if hanaga.get_node("AnimationPlayer").get_current_animation() !="walk":
				hanaga.get_node("AnimationPlayer").play("walk")
		
		if  hanagaFollow.get_unit_offset() <= 0.1455:
			hanaga.set_rotation_deg(Vector3(0,180,0))
		
		if  hanagaFollow.get_unit_offset() >= 0.1455 and hanagaFollow.get_unit_offset() <= 0.3326:
			hanaga.set_rotation_deg(Vector3(0,-90,0))
		
		if  hanagaFollow.get_unit_offset() >= 0.3326 and hanagaFollow.get_unit_offset() <= 0.4714:
			hanaga.set_rotation_deg(Vector3(0,0,0))
			
		if hanagaFollow.get_unit_offset() >= 0.4714 and hanagaFollow.get_unit_offset()  <= 0.6:
			hanaga.set_rotation_deg(Vector3(0,-90,0))
		
		if hanagaFollow.get_unit_offset() >= 0.9636 and hanagaFollow.get_unit_offset()  <= 1:
			hanaga.set_rotation_deg(Vector3(0,180,0))
			
		if hanagaFollow.get_unit_offset() >= 0.6:
			move = false
			hanaga.set_rotation_deg(Vector3(0,180,0))
			#global.set_hanagaSalaVidro(true)
			hanaga.get_node("AnimationPlayer").play("idle")
			hanaga.get_node("AnimationPlayer").play("idle")
			set_process(false)
			global.set_hanagaChapter(7)
	####################################3
	else:
		if move == false:
			if hanaga.get_node("AnimationPlayer").get_current_animation() !="idle":
				hanaga.get_node("AnimationPlayer").play("idle")
		
		elif move:
			if hanaga.get_node("AnimationPlayer").get_current_animation() !="walk":
				hanaga.get_node("AnimationPlayer").play("walk")
		
		if  hanagaFollow.get_unit_offset() <= 0.6364:
			hanaga.set_rotation_deg(Vector3(0,180,0))
		
		if  hanagaFollow.get_unit_offset() >= 0.6364 and hanagaFollow.get_unit_offset() <= 0.7818:
			hanaga.set_rotation_deg(Vector3(0,180,0))
		
		if  hanagaFollow.get_unit_offset() >= 0.7818 and hanagaFollow.get_unit_offset() <= 0.9990:
			hanaga.set_rotation_deg(Vector3(0,90,0))
			
			
		if hanagaFollow.get_unit_offset() >= 0.9999:
			move = false
			global.set_hanagaSalaVidro(false)
			#global.set_hanagaSalaVidro(true)
			hanaga.get_node("AnimationPlayer").play("idle")
			hanaga.get_node("AnimationPlayer").play("idle")
			global.set_hanagaChapter(10)
			set_process(false)
