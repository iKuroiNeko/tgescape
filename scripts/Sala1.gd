extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("DialogPanel/TIE")
onready var panel = get_node ("DialogPanel")
onready var msg = get_node("Message/Label")
onready var puzzlePaper = get_node("sala1/papelPuzzle")
onready var puzzlePenDrive = get_node("sala1/penDrive")
onready var puzzles = get_node("Puzzles")
onready var armarioPuzzle = get_node("Puzzles/puzzleArmarioSala1")
onready var telaVerde = get_node("Puzzles/puzzleLife")
onready var portaVidro = get_node("sala1/portaVidro")
onready var anim = get_node("AnimationPlayer")
onready var boneAtt = get_node("Haku/Armature/Skeleton/BoneAttachment" )
onready var timer = get_node("Timer")
onready var hanagaFollow = get_node("Hanaga/PathFollow")
onready var smrt = get_node("Canvas/dialog")

var p = null

var weapon = null
var texto = null
var pressArea = false
var dialogavel = true
var buffEnd = false
var temItem = false
var item = null
var area = null 
var puzzleNode 
var temPuzzle = false
var inventarioAberto = false
var temChave = false
var array1 = []
var portaTrancada
var pdPicked
var paperPicked
var canInteract = false
var hanagaTrancado = false
var isPlantaQuadro = false

var seconds = 0
var elapsed = 0
var time_now = 0
var time_start = OS.get_unix_time()



func _ready():
	# tirar
	
	set_process_input(true)
	array1 = global.get_itemArray()
	Inventory.updateItems()
	portaTrancada = global.get_quarto1Trancado()
	paperPicked = global.get_paperPicked()
	pdPicked = global.get_pdPicked()
	if paperPicked:
		puzzlePaper.hide()
		temItem = false
		get_node("Areas/AreaPapel").queue_free()
	if pdPicked:
		puzzlePenDrive.hide()
		temItem = false
		get_node("Areas/AreaPenDrive").queue_free()
		
	weapon = global.get_weapon()
	
#	if global.get_portaVidroFechada() == false:
#		anim.play("glassDoor")
	
		
	#posição inicial do player
	char.set_translation(global.get_charPos())
	if weapon != null:
		get_node("Haku/Armature/Skeleton/BoneAttachment/" + weapon).show()
		global.set_canHit(true)
	else:
		global.set_canHit(false)
#	global.set_hanagaSala1(true)
#	global.set_arinaSala1(true)
#	global.set_feiSala1(true)
#	global.set_arinaChapter(5)
#	global.set_feiChapter(5)
	#global.set_hanagaChapter(5)
	if global.get_hanagaSala1():
		get_node("Hanaga").show()
	else:
		get_node("Hanaga").queue_free()
	
	if global.get_arinaSala1():
		get_node("arina").show()
	else:
		get_node("arina").queue_free()
	
	if global.get_feiSala1():
		get_node("Fei").show()
	else:
		get_node("Fei").queue_free()
	
	if global.get_hanagaSalaVidro():
		get_node("Hanaga/PathFollow").set_unit_offset(0.6)
	
func _input(event):
	
	if event.is_action_pressed("actionButton") and pressArea and dialogavel and Inventory.inventoryAberto== false:
		if texto != null:
			dialog(texto)
			dialogavel = false
			global.set_qtdInteracoes()
			if isPlantaQuadro:
				global.set_openness(5)
	if event.is_action_pressed("actionButton") and !dialogavel and buffEnd:
		_on_TIE_buff_end()
	if event.is_action_pressed("actionButton") and temItem:
		if item != null:
			pickItem(item)
			global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and temPuzzle and pressArea:
		p.openPuzzle()
		dialogavel = false
		pressArea = false
		global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and pressArea and temChave == false:
		if texto != null:
			dialog(texto)
			dialogavel = false
			global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and canInteract:
		if area == "portaVidro" and global.get_hanagaSalaVidro() and global.get_hanagaChapter() == 8:
			smrt.show_text("portaVidro","text1")
			global.set_canMove(false)
			global.set_canInventory(false)
			canInteract = false
		elif area == "portaVidro" and global.get_hanagaSalaVidro() and global.get_hanagaChapter() == 9:
			smrt.show_text("portaVidro","text2")
			global.set_canMove(false)
			global.set_canInventory(false)
			canInteract = false
		elif area =="maquinas" and global.get_maquinaSala1Chapter() == 1:
			smrt.show_text("MaquinaSala1","text1")
			global.set_canMove(false)
			global.set_canInventory(false)
			canInteract = false
		elif area == "maquinas" and global.get_maquinaSala1Chapter() == 2:
			smrt.show_text("MaquinaSala1","text4")
			global.set_canMove(false)
			global.set_canInventory(false)
			canInteract = false
		elif area == "hanaga":
			if global.get_hanagaChapter() == 5:
				print("chapter 5")
				smrt.show_text("hanagaSala1","text1")
				canInteract = false
			elif global.get_hanagaChapter() == 6:
				print("chapter 6")
				smrt.show_text("hanagaSala1","text3")
				canInteract = false
			elif global.get_hanagaChapter() == 7:
				smrt.show_text("hanagaSala1","text4")
				canInteract = false
			
			elif global.get_hanagaChapter() == 10:
				print ("chapter 10")
				smrt.show_text("hanagaSala1","text5")
				canInteract = false
			global.set_canMove(false)
			global.set_canInventory(false)
		
		elif area == "arina":
			if global.get_arinaChapter() == 5 or global.get_arinaChapter() == 4:
				smrt.show_text("arinaSala1","text1")
				canInteract = false
			elif global.get_arinaChapter() == 6:
				smrt.show_text("arinaSala1","text2")
				canInteract = false
			global.set_canMove(false)
			global.set_canInventory(false)
			
		elif area == "fei":
			if global.get_feiChapter() == 5 or global.get_feiChapter() == 4:
				smrt.show_text("feiSala1","text1")
				canInteract = false
			elif global.get_feiChapter() == 6:
				smrt.show_text("feiSala1","text2")
				canInteract = false
			global.set_canMove(false)
			global.set_canInventory(false)
			
	if event.is_action_pressed("actionButton") and area == "estante":
		if global.get_papelFrase() == false:
			Inventory.addItem("Papel com Frase")
			Inventory.updateItems()
			global.set_papelFrase(true)
			msg.show()
			msg.set_text("Você encontrou o item: Papel com frase")
			timer.start()
		
func _on_AreaQuadro_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "Que criatura é essa????"
		

func dialog(texto):
	if dialogavel and buffEnd==false:
		global.set_canMove(false)
		panel.show()
		tie.reset()
		tie.buff_text(texto, 0.005)
		tie.set_state(tie.STATE_OUTPUT)
		global.set_canInventory(false)
		pressArea = false
		global.set_canHit(false)

func _on_TIE_buff_end():
	dialogavel = false
	buffEnd = true
	pressArea = true
	if Input.is_action_pressed("actionButton") and dialogavel == false and buffEnd:
		tie.reset()
		panel.hide()
		dialogavel = false
		buffEnd = false
		global.set_canMove(true)
		global.set_canInventory(true)
		global.set_canHit(true)

func _on_Area_body_exit( body ):
	pressArea = false
	dialogavel = false
	temPuzzle = false
	texto = null
	temItem = false
	item = null
	isPlantaQuadro = false
	area = null
	p = null
	charArea = null

func _on_AreaPuzzle1_body_enter( body ):
	if body == char:
		temItem = true
		item = "Papel estranho"
		area = "Areas/AreaPuzzle1"
		puzzleNode = get_node("FirstRoom/papelPuzzle1")

func pickItem(item):
	if item == puzzlePenDrive:
		puzzlePenDrive.hide()
		temItem = false
		msg.show()
		msg.set_text("Você pegou o item: Pen Drive")
		Inventory.addItem("Pen Drive")
		global.set_pdPicked(true)
		timer.start()
		get_node("Areas/AreaPenDrive").queue_free()
		global.set_canInventory(true)
		global.set_canMove(true)
	elif item == puzzlePaper:
		puzzlePaper.hide()
		msg.show()
		msg.set_text("Você pegou o item: Papel Rabiscado")
		temItem = false
		Inventory.addItem("Papel rabiscado")
		global.set_paperPicked(true)
		timer.start()
		get_node("Areas/AreaPapel").queue_free()

func _on_AreaItem_body_exit( body ):
	temItem = false
	item = null
	area = null

func _on_Timer_timeout():
	msg.hide()


func _on_AreaPorta_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		area = "AreaPorta"
		verifChave()
		if portaTrancada == false:
			for i in range(0, array1.size()):
				if array1[i] == "Chave do quarto":
					array1.remove(i)
					print("free item")
					print(i)
					Inventory.updateItems()
			for i in range(0, array1.size()):
				if array1[i] == "Papel estranho":
					array1.remove(i)
					print("free item")
					print(i)
					Inventory.updateItems()

func _on_AreaArmario_body_enter( body ):
	if body == char: 
		temPuzzle = true
		pressArea = true
		p = armarioPuzzle
		

func _on_AreaPlanta_body_enter( body ):
	if body == char:
		texto = "Uma planta."
		dialogavel = true
		pressArea = true
		isPlantaQuadro = true
		if Input.is_action_pressed("actionButton"):
			global.set_openness(5)

func _on_AreaTelaVerde_body_enter( body ):
	if body == char:
		temPuzzle = true
		pressArea = true
		p = telaVerde


func _on_AreaPortaC1_body_enter( body ):
	if body == char:
		Transition.fade_to("Corredor2.tscn")
		global.set_charPos(Vector3(-66.259201,-1.72326,14.180042))


func _on_AreaPenDrive_body_enter( body ):
	if body == char:
		pressArea = true
		temItem = true
		item = puzzlePenDrive
		area = "penDrive"


func _on_AreaPapel_body_enter( body ):
	if body == char:
		pressArea = true
		temItem = true
		item = puzzlePaper
		area = "areaPapel"

func _on_AreaPC_body_enter( body ):
	if body == char:
		pressArea = true
		if global.get_puzzlePCS1Res() == false:
			if global.get_pdPicked():
				#temPuzzle = true
				dialogavel = true
				if global.get_hanagaSala1():
					texto = "Coloquei o pen drive no computador...\nAh! A porta da sala se abriu! Mas Hanaga ficou trancado! D:"
					global.set_hanagaSalaVidro(true)
					global.set_hanagaChapter(8)
				else:
					texto = "Ah! Aquela porta se abriu!"
				global.set_corredor3Trancado(false)
				array1 = global.get_itemArray()
				global.set_puzzlePCS1Res(true)
				for i in range(0, array1.size()):
					if array1.has("Pen Drive"):
						array1.erase("Pen Drive")
						#print(str(array1[i]))
						#global.set_itemArray(array1)
						Inventory.updateItems()
						break
				anim.play_backwards("glassDoor")
				
			else:
				dialogavel = true
				texto = "Não tem nada de útil no computador"
		elif global.get_puzzlePCS1Res():
			dialogavel = true
			pressArea = true
			texto = "Não consigo mais acessar o computador... melhor deixar assim."

func _on_AreaPortaC3_body_enter( body ):
	if body == char:
		if global.get_corredor3Trancado():
			pressArea = true
			dialogavel = true
			texto = "Tá trancado..."
		else:
			Transition.fade_to("Corredor3.tscn")
			global.set_charPos(Vector3(-18.671108,-1.72326,17.126551))
			if global.get_arinaSala1():
				global.set_arinaSala2(true)
				global.set_arinaSala1(false)
			if global.get_hanagaSalaVidro() == false and global.get_hanagaSala1():
				global.set_hanagaSala2(true)
				if global.get_feiSala1():
					global.set_feiSala2(true)
					global.set_feiSala1(false)
				global.set_hanagaSala1(false)
				
			

func _on_AreaMaquina_body_enter( body ):
	if body == char:
		pressArea = true
		canInteract = true
		area = "maquinas"
		


func _on_AreaMaquina2_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "Parece estar desligado..."


func _on_AreaEstante_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		if global.get_hanagaSala1():
			if global.get_hanagaSalaVidro():
				if global.get_papelFrase() == false:
					texto = "Será que não tem nada que possa me ajudar aqui...?\n. . . \nAh! Tem um papel solto aqui!"
				else:
					texto = "Não tem mais nada de interessante aqui."
				area = "estante"
			else:
				texto = "Tem muitos livros, parecem ser sobre humanos. Mas que língua é essa?"
		else:
			texto = "Tem muitos livros, parecem ser sobre humanos. Mas que língua é essa?\n. . . \nNão entendo..."

func _on_AreaPortaVidro_body_enter( body ):
	if body == char:
		area = "portaVidro"
		canInteract = true
		

func _on_dialog_dialog_control( info ):
	global.set_canHit(false)
	if info.chapter == "MaquinaSala1":
		if info.dialog == "text1":
			if info.answer == 0:
				global.set_organizacao(-10)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MaquinaSala1","text2")
				global.set_maquinaSala1Chapter(2)
			elif info.answer == 1:
				global.set_organizacao(10)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MaquinaSala1","text3")
				global.set_maquinaSala1Chapter(2)
	elif info.chapter == "hanagaSala1":
		if info.dialog == "text1":
			if info.answer == 0:
				global.set_assertividade(5)
				global.set_retratacao(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("hanagaSala1","text2")
				global.set_hanagaChapter(6)
			elif info.answer == 1:
				global.set_assertividade(-5)
				global.set_entusiasmo(-5)
				global.set_retratacao(5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("hanagaSala1","text2_2")
				global.set_hanagaChapter(6)
	elif info.chapter == "portaVidro":
		if info.dialog == "text1":
			if info.answer == 0:
				global.set_assertividade(5)
				global.set_compassion(5)
				global.set_politeness(5)
				global.set_volatilidade(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("portaVidro","text2")
				global.set_hanagaChapter(9)
			elif info.answer == 1:
				global.set_volatilidade(5)
				global.set_politeness(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("portaVidro","text2")
				global.set_hanagaChapter(9)
	elif info.chapter == "arinaSala1":
		if info.dialog == "text1":
			if info.answer == 0:
				global.set_entusiasmo(-5)
				global.set_assertividade(-5)				
				global.set_arinaChapter(6)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("arinaSala1","text2")
			elif info.answer == 1:
				global.set_politeness(5)
				global.set_assertividade(5)
				global.set_retratacao(-5)
				global.set_arinaChapter(6)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("arinaSala1","text2")
			elif info.answer == 2:
				global.set_politeness(-10)
				global.set_entusiasmo(-5)
				global.set_retratacao(5)
				global.set_arinaChapter(6)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("arinaSala1","text2")
	elif info.chapter == "feiSala1":
		if info.dialog == "text1":
			if info.answer == 0:
				global.set_assertividade(5)
				global.set_politeness(5)
				global.set_entusiasmo(5)
				global.set_feiChapter(6)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiSala1","text2_2")
			if info.answer == 1:
				global.set_assertividade(-5)
				global.set_entusiasmo(-5)
				global.set_retratacao(5)
				global.set_feiChapter(6)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiSala1","text2")
				
func _on_dialog_finished():
	global.set_canInventory(true)
	global.set_canMove(true)
	global.set_canHit(true)

var charArea = null

func _on_AreaHanaga_body_enter( body ):
	if body == char:
		canInteract = true
		area = "hanaga"
		pressArea = true
	
	
func _on_AreaArina_body_enter( body ):
	if body == char:
		canInteract = true
		area = "arina"
		pressArea = true


func _on_AreaFei_body_enter( body ):
	if body == char:
		canInteract = true
		area = "fei"
		pressArea = true
