extends Control

onready var tie = get_node("Panel/TIE")
onready var panel = get_node("Panel")
onready var msg = get_node("../../Message")
onready var option = get_node("OptionPanel")
onready var smrt = get_node("Canvas/dialog")

var weapon = null
var resolvido
var puzzleAberto = false
var buffEnd = false
var textOpen = false
var temPergunta
var time_start = OS.get_unix_time()
var time_now = 0
var seconds
var elapsed
var array1
var teste = false

func _ready():	
	set_process_input(true)
	resolvido = global.puzzle3Res
	array1 = global.get_itemArray()
func _process(delta):
	seconds = 0
	elapsed = 0
	time_now = OS.get_unix_time()
	elapsed = time_now - time_start
	seconds = elapsed
	print("elapsed : ", seconds)

func _input(event):
	if event.is_action_pressed("cancelButton") and puzzleAberto:
		closePuzzle()
		puzzleAberto = false
#	if event.is_action_pressed("actionButton") and buffEnd:
#		closePuzzle()
#		puzzleAberto = false
	if event.is_action_pressed("actionButton"):
		if textOpen:
			global.set_canMove(true)
			global.set_canInventory(true)
			textOpen = false
	#if event.is_action_pressed("hitButton"):
	#	if teste:
	#		panel.hide()
	#		tie.reset()
	#		set_process(false)
		

func openPuzzle():
	if resolvido == false:
		self.show()
		puzzleAberto = true
		dialog()
		global.set_canMove(false)
		global.set_canInventory(false)
		set_process(true)
		time_start = OS.get_unix_time()
		global.set_canHit(false)
	else: return
	
func closePuzzle():
	self.hide()
	puzzleAberto = false
	tie.reset()
	set_process(false)
	global.set_puzzleTime(elapsed)
	global.set_canMove(true)
	global.set_canInventory(true)
	global.set_canHit(true)
	
	
func _on_TIE_buff_end():
	buffEnd = true

func dialog():
	buffEnd = false
	tie.reset()
	tie.buff_text("Posso colocar um código aqui. (Confirmar: Enter, Cancelar X)\n", 0.005)
	tie.buff_input()
	tie.set_state(tie.STATE_OUTPUT)

func _on_TIE_input_enter( input ):
	tie.reset()
	if input == "1024":
		resolvido = true
		global.set_puzzle3Res(resolvido)
		panel.hide()
		global.set_canMove(false)
		global.set_canInventory(false)
		
#		smrt.show_text("weapon","text")
#		smrt.stop()
#		yield(get_tree(),"idle_frame")
		smrt.show_text("weapon","text")
		for i in range (0,array1.size()):
			if array1[i] == "Papel desenhado":
				array1.remove(i)
				Inventory.updateItems()
				break
		Inventory.addItem("Chave do Corredor")
		set_process(false)
#		tie.buff_text("Há alguns objetos que posso usar para me defender.\n Qual devo levar? \n Selecionar: Enter", 0.005)
		buffEnd = true
		if global.get_arinaCorredor1() == false:
			global.set_feiChapter(4)
		else:
			global.set_feiChapter(3)
		closePuzzle()
	
	else:
		tie.buff_text(".....", 0.005)
		buffEnd = true
		set_process(false)
	 tie.set_state(tie.STATE_OUTPUT)

#func _on_dialog_finished():
#	global.set_canMove(true)
#	global.set_canInventory(true)

	
func _on_dialog_dialog_control( info ):
	#global.set_canInventory(false)
	#global.set_canMove(false)
	if info.dialog == "text":
		if info.answer == 0:
			global.set_weapon("vassoura")
			get_node("../../Haku/Armature/Skeleton/BoneAttachment/" + global.get_weapon()).show()
			#closePuzzle()
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("weapon","text",2)
#			if info.last_text_index == info.total_text:
#				global.set_canMove(true)
			global.set_organizacao(10)
			textOpen = true
		if info.answer == 1:
			global.set_weapon("umbrella")
			get_node("../../Haku/Armature/Skeleton/BoneAttachment/" + global.get_weapon()).show()
			#closePuzzle()
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("weapon","text",2)
#			if info.last_text_index == info.total_text:
#				global.set_canMove(true)
			global.set_intelecto(10)
			textOpen = true
		if info.answer == 2:
			global.set_weapon("stick")
			get_node("../../Haku/Armature/Skeleton/BoneAttachment/" + global.get_weapon()).show()
			#closePuzzle()
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("weapon","text",2)
			global.set_openness(10)
			textOpen = true
#			if info.last_text_index == info.total_text:
#				global.set_canMove(true)
		if info.answer == 3:
			smrt.stop()
			smrt.show_text("weapon","text",2)
			global.set_weapon("balaoRosa")
			get_node("../../Haku/Armature/Skeleton/BoneAttachment/" + global.get_weapon()).show()
			#closePuzzle()
			yield(get_tree(),"idle_frame")
#			if info.last_text_index == info.total_text:
#				global.set_canMove(true)
			textOpen = true
			teste = true
			global.set_openness(10)
			global.set_entusiasmo(5)
			global.set_volatilidade(-10)
		global.set_canHit(true)