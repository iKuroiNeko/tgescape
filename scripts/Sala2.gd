extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("Panel/TIE")
onready var panel = get_node ("Panel")
onready var msg = get_node("Message/Label")
onready var inventory = get_node("Inventory")
onready var puzzles = get_node("Puzzles")
onready var puzzlePoster = get_node("Puzzles/Poster")
onready var menu = get_node("Inventory/Panel/menu")
onready var boneAtt = get_node("Haku/Armature/Skeleton/BoneAttachment" )
onready var ameba1 = get_node("Puzzles/Ameba1")
onready var ameba2 = get_node("Puzzles/Ameba2")
onready var ameba3 = get_node("Puzzles/Ameba3")
onready var ameba4 = get_node("Puzzles/Ameba4")
onready var plantas = get_node("Puzzles/Plantas")
onready var armarioPuzzle = get_node("Puzzles/PuzzleArmarioSala2")
onready var armario2Puzzle = get_node("Puzzles/PuzzleArmario2Sala2")
onready var bauPuzzle = get_node("Puzzles/puzzleBauSala2")
onready var monitor = get_node("Puzzles/MonitorSala2")
onready var areaEstante = get_node("Areas/AreaEstante")
onready var areaMaquina = get_node("Areas/AreaMaquina")
onready var smrt = get_node("Canvas/dialog")


onready var hanaga = get_node("Hanaga")
onready var hanagaExp = get_node("Hanaga/Expression")

onready var fei = get_node("Fei")
onready var feiExp = get_node("Fei/Expression")

onready var arina = get_node("arina")
onready var arinaExp = get_node("arina/Expression")


var p = null
var img = null
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
#var paperPicked
var itemEstante
var puzzleAberto = false
var cartao = false
var piaInteract = false
var canInteract = false

var seconds = 0
var elapsed = 0
var time_now = 0
var time_start = OS.get_unix_time()
		
func _process(delta):
	seconds = 0
	elapsed = 0
	time_now = OS.get_unix_time()
	elapsed = time_now - time_start
	seconds = elapsed
	print("elapsed : ", seconds)

func _ready():
	
	set_process_input(true)
	array1 = global.get_itemArray()
	inventory.updateItems()
	itemEstante = global.get_estanteItemPickedSala2()
	portaTrancada = global.get_corredor4Trancado()
	weapon = global.get_weapon()
	
	#global.set_arinaSala2(true)
	#global.set_hanagaSala2(true)
	#global.set_feiSala2(true)
	
	#posição inicial do player
	char.set_translation(global.get_charPos())
	if weapon != null:
		get_node("Haku/Armature/Skeleton/BoneAttachment/" + weapon).show()
		global.set_canHit(true)
	else:
		global.set_canHit(false)
		
	if global.get_hanagaSala2():
		areaMaquina.queue_free()
		hanaga.show()
	else:
		hanaga.queue_free()
	
	if global.get_entregouColar() == false:
		if global.get_feiColarCorredor4() == false: 
			if global.get_feiSala2():
				areaEstante.queue_free()
				fei.show()
			else:
				fei.queue_free()
		else: #fei falou sobre colar
			if global.get_feiAnswerNo(): #se respondeu compra outro
				areaEstante.queue_free()
				fei.show()
				fei.set_translation(Vector3(4,1,-25))
				fei.set_rotation_deg(Vector3(0,-59,0))
			else:
				fei.queue_free()
	else: #já entregou colar 
		fei.queue_free()
		
		
	
	if global.get_arinaSala2():
		arina.show()
	else:
		arina.queue_free()
	
func _input(event):
	if event.is_action_pressed("hitButton") and char.move == false:
		char.playHit()
	if event.is_action_pressed("actionButton") and pressArea and dialogavel and inventory.inventoryAberto== false:
		if texto != null:
			dialog(texto)
			dialogavel = false
			global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and !dialogavel and buffEnd:
		_on_TIE_buff_end()
	if event.is_action_pressed("actionButton") and temPuzzle and pressArea:
		p.openPuzzle()
		global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and pressArea and temChave == false:
		if texto != null:
			dialog(texto)
			dialogavel = false
			global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and pressArea and area == "AreaEstante" and global.get_estanteItemPickedSala2() == false:
		inventory.addItem("Cartão de memória")
		global.set_estanteItemPickedSala2(true)
	if event.is_action_pressed("actionButton") and pressArea and area == "AreaFluido" and global.get_fluidoResolvidoSala2() == false:
		inventory.addItem("Chave gabinete")
		global.set_fluidoResolvidoSala2(true)
	if event.is_action_pressed("cancelButton") and puzzleAberto and pressArea:
		closeImage(img)
		set_process(false)
		global.set_puzzleTime(elapsed)
		
	if event.is_action_pressed("actionButton") and img != null and pressArea:
		openImage(img)
		set_process(true)
		time_start = OS.get_unix_time()
		global.set_qtdInteracoes()
		
#	if event.is_action_pressed("actionButton") and cartao and pressArea:
#		verifCartao()
#		cartao = false
	#if event.is_action_pressed("actionButton") and area == "AreaPia" and pressArea:
	#	verificaPia()
	if event.is_action_pressed("actionButton") and piaInteract and pressArea:
		verificaPia()
		piaInteract = false
		
	if event.is_action_pressed("actionButton") and canInteract:
		#global.set_canMove(false)
		#global.set_canInventory(false)
		#### FEI #######################################
		if area == "fei":

			if global.get_feiSala2Chapter() == 1:
				smrt.show_text("feiSala2","fei2_1")
				
			elif global.get_feiSala2Chapter() == 2:
				smrt.show_text("feiSala2","fei2_4")
			
			elif global.get_feiSala2Chapter() == 3 and global.get_colarPicked() == false:
				smrt.show_text("feiColar","text1")
				
			elif global.get_feiSala2Chapter() == 4 and global.get_colarPicked() == false:
				smrt.show_text("feiColar","text2")
				
			elif global.get_feiSala2Chapter() == 3 and global.get_colarPicked() or global.get_feiSala2Chapter() == 4 and global.get_colarPicked():
				smrt.show_text("feiColar","text3")
				for i in range(0, array1.size()):
					if array1[i] == "Colar da Fei":
						array1.remove(i)
					break
				inventory.updateItems()
				global.set_entregouColar(true)
				if global.get_saidaTrancado() == false:
					global.set_feiSaida(true)
				elif global.get_saidaTrancado():
					global.set_feiSala3(true)

			########### HANAGA #############
		elif area == "hanaga":
			if global.get_hanagaSala2Chapter() == 1:
				smrt.show_text("hanagaSala2","hanaga2_1")
				
			elif global.get_hanagaSala2Chapter() == 2:
				smrt.show_text("hanagaSala2","hanaga2_2")

				#######  ARINA ##########
		elif area == "arina":
			if global.get_arinaSala2Chapter() == 1:
				smrt.show_text("arinaSala2","arina2_1")

			elif global.get_arinaSala2Chapter() == 2:
				smrt.show_text("arinaSala2","arina2_2")

		global.set_canMove(false)
		global.set_canInventory(false)
		canInteract = false
				
func dialog(texto):
	if dialogavel and buffEnd==false:
		global.canMove = false
		panel.show()
		tie.reset()
		tie.buff_text(texto, 0.05)
		tie.set_state(tie.STATE_OUTPUT)
		global.set_canInventory(false)
		global.set_canHit(false)
		
func _on_TIE_buff_end():
	dialogavel = false
	buffEnd = true
		
	if Input.is_action_pressed("actionButton") and dialogavel == false and buffEnd:
		tie.reset()
		panel.hide()
		dialogavel = false
		buffEnd = false
		global.canMove = true
		global.set_canInventory(true)
		global.set_canHit(true)
		
func _on_Area_body_exit( body ):
	pressArea = false
	dialogavel = false
	temPuzzle = false
	texto = null
	temItem = false
	item = null
	p = null
	img = null
	area = null

	
func openImage(img):
	img.show()
	global.set_canMove(false)
	dialogavel = false
	global.set_canInventory(false)
	puzzleAberto = true
	global.set_canHit(false)
	
func closeImage(img):
	puzzleAberto = false
	img.hide()
	global.set_canMove(true)
	dialogavel = true
	global.set_canInventory(true)
	global.set_canHit(true)
	img = null
func _on_AreaPlanta_body_enter( body ):
	if body == char:
		pressArea = true
		img = plantas
		#texto = "Várias plantas coloridas."
		#dialogavel = true
		#pressArea = true

func _on_AreaArmario2_body_enter( body ):
	if body == char:
		#dialogavel = true
		pressArea = true
		#area = "AreaArmario2"
		#if global.get_panoSujoPicked() == false:
		#	texto = "O armário estava aberto... Peguei um pedaço de pano sujo."
		#else:
		#	texto = "Não tem mais nada aqui..."
		temPuzzle = true
		p = armario2Puzzle
		


func _on_AreaArmario1_body_enter( body ):
	if body == char:
		pressArea = true
		temPuzzle = true
		p = armarioPuzzle


func _on_AreaPoster_body_enter( body ):
	if body == char:
		img = puzzlePoster
		pressArea = true

func _on_AreaMicroscopio1_body_enter( body ):
	if body == char:
		pressArea = true
		img = ameba1
		
func _on_AreaMicroscopio2_body_enter( body ):
	if body == char:
		pressArea = true
		img = ameba2

func _on_AreaMicroscopio3_body_enter( body ):
	if body == char:
		pressArea = true
		img = ameba3

func _on_AreaMicroscopio4_body_enter( body ):
	if body == char:
		pressArea = true
		img = ameba4

func _on_AreaEstante_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "Livros... Não entendo o que tá escrito..."
		

func _on_AreaBau_body_enter( body ):
	if body == char:
		pressArea = true
		temPuzzle = true
		p = bauPuzzle

func _on_AreaMonitor_body_enter( body ):
	if body == char:
		pressArea = true
		temPuzzle = true
		p = monitor


func _on_AreaMaquina_body_enter( body ):
	if body == char:
		texto = "Pra que servem essas máquinas?"
		dialogavel = true
		pressArea = true


func _on_AreaPia_body_enter( body ):
	if body == char:
		pressArea = true
		dialogavel = true 
		#area = "AreaPia"
		piaInteract = true
		
func verificaPia():
	var dialogo = null
	buffEnd = false
	if global.get_fluidoResolvidoSala2() == false:
		if global.get_panoSujoPicked() == false:
			dialogo = "Uma pia, tem uns copos...\nE o gabinete está trancado..."

		else:
			dialogo = "Vou tentar limpar o pano com água.\n. . . \nNão sai a sujeira..."
	else:
		if global.get_cabineteSala2() == false:
			dialogo = "Agora posso abrir o gabinete.\nTem um produto aqui dentro."
			for i in range(0, array1.size()):
				if array1[i] == "Chave gabinete":
					array1.remove(i)
					break
			inventory.updateItems()
			inventory.addItem("Produto")
			global.set_cabineteSala2(true)
		elif global.get_cabineteSala2():
			if global.get_panoSujoPicked():
				if global.get_panoLimpoSala2() == false:
					dialogo = "Posso tentar usar o produto pra limpar o pano...\n. . .\nApareceu uma coisa..."
					global.set_panoLimpoSala2(true)
					for i in range(0, array1.size()):
						if array1[i] == "Produto":
							array1.remove(i)
							break
					inventory.updateItems()
					for i in range(0, array1.size()):
						if array1[i] == "Pedaço de pano sujo":
							array1.remove(i)
							break
					inventory.updateItems()
					inventory.addItem("Pedaço de pano")
				else:
					dialogo = "Não tem mais nada pra fazer aqui."
			else:
				dialogo = "Por que tinha um produto aqui embaixo...?"
	if dialogavel and buffEnd == false:
		dialogavel = false
		global.canMove = false
		panel.show()
		tie.reset()
		tie.buff_text(dialogo, 0.05)
		tie.set_state(tie.STATE_OUTPUT)
		global.set_canInventory(false)

func _on_AreaFluidos_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		area = "AreaFluido"
		if global.get_fluidoResolvidoSala2() == false:
			texto = "Fluidos coloridos...\nTem uma coisa aqui embaixo...\nUma chave..."
			#inventory.addItem("Cartão de memória")
			#global.set_estanteItemPickedSala2(true)
		else:
			texto = "Fluidos coloridos."

func verifChave():
	array1 = global.itemArray
	if global.get_corredor4Trancado():
		if global.get_bauSala2() == false:
			texto = "Está trancada..."
		else:
			if global.get_chaveRustSala2() == false:
				print("destranquei")
				portaTrancada = false
				global.set_corredor4Trancado(portaTrancada)
				#get_node("Sample").play("doorOpen")
				Transition.fade_to("Corredor4.tscn")
				global.set_charPos(Vector3(20,1.7,19))
				for i in range(0, array1.size()):
					if array1[i] == "Chave sala dois":
						array1.remove(i)
						break
					#if array1[i] == "Pedaço de pano":
					#	array1.remove(i)
					break
				inventory.updateItems()
				
				global.set_arinaSala3(global.get_arinaSala2())
				global.set_feiSala3(global.get_feiSala2())
				global.set_hanagaSala3(global.get_hanagaSala2())
				global.set_arinaSala2(false)
				global.set_feiSala2(false)
				global.set_hanagaSala2(false)
				
			else:
				texto = "Não consigo abrir...\nA chave está muito enferrujada... "
	else:
		
		Transition.fade_to("Corredor4.tscn")
		global.set_charPos(Vector3(20,1.7,19))

func _on_AreaPorta1_body_enter( body ):
	if body == char:
		if global.get_corredor4Trancado():
			pressArea = true
			dialogavel = true
			verifChave()
			#texto = "Tá trancado..."
		else:
			Transition.fade_to("Corredor4.tscn")
			global.set_charPos(Vector3(20,1.7,19))
			

func _on_AreaPorta2_body_enter( body ):
	if body == char:
		Transition.fade_to("Corredor3.tscn")
		global.set_charPos(Vector3(35,-1.7,3))


func _on_AreaOleo_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		if global.get_corredor4Trancado():
			if global.get_bauSala2() == false:
				texto = "Está vazando óleo das máquinas...."
			else:
				if global.get_chaveRustSala2():
					texto = "Posso passar a chave no óleo."
					global.set_chaveRustSala2(false)
				else:
					texto = "Não preciso passar a chave no óleo de novo..."
		else:
			texto = "Está vazando óleo das máquinas...."


func _on_Timer_timeout():
	msg.hide()


func _on_dialog_finished():
	global.set_canMove(true)
	global.set_canInventory(true)


func _on_dialog_dialog_control( information ):
	global.set_canMove(false)
	global.set_canInventory(false)
	#if global.get_feiSala2Chapter() == 1:
	if information.dialog == "fei2_1":
		if information.answer == 0:
			smrt.stop() # We kindly ask SMRT to stop
			yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
			smrt.show_text("feiSala2","fei2_2") # to finally follow it with a new dialog
			global.set_entusiasmo(5)
			#global.set_feiSala2Chapter(2)
		elif information.answer == 1:
			smrt.stop() # We kindly ask SMRT to stop
			yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
			smrt.show_text("feiSala2","fei2_3") # to finally follow it with a new dialog
			global.set_intelecto(-10)
			global.set_entusiasmo(5)
			#global.set_feiSala2Chapter(2)
		elif information.answer == 2:
			smrt.stop() # We kindly ask SMRT to stop
			yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
			smrt.show_text("feiSala2","fei2_4") # to finally follow it with a new dialog
			global.set_entusiasmo(-10)
			global.set_assertividade(-5)
		global.set_feiSala2Chapter(2)
		
	if information.dialog == "text1":
		if information.answer == 0:
			smrt.stop() # We kindly ask SMRT to stop
			yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
			smrt.show_text("feiColar","text2") # to finally follow it with a new dialog
			global.set_feiSala2Chapter(4)
	
	#### HANAGA #######
	#elif global.get_hanagaSala2Chapter() == 1:
	if information.dialog == "hanaga2_1":
		if information.answer == 0:
			smrt.stop() # We kindly ask SMRT to stop
			yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
			smrt.show_text("hanagaSala2","hanaga2_2") # to finally follow it with a new dialog
			global.set_volatilidade(5)
			global.set_politeness(-5)
			#global.set_hanagaSala2Chapter(2)
		elif information.answer == 1:
			smrt.stop() # We kindly ask SMRT to stop
			yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
			smrt.show_text("hanagaSala2","hanaga2_2") # to finally follow it with a new dialog
			global.set_assertividade(5)
			#global.set_hanagaSala2Chapter(2)
		elif information.answer == 2:
			smrt.stop() # We kindly ask SMRT to stop
			yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
			smrt.show_text("hanagaSala2","hanaga2_2") # to finally follow it with a new dialog
			global.set_entusiasmo(-5)
			global.set_assertividade(-5)
		global.set_hanagaSala2Chapter(2)
	
	##### ARINA #########
	#elif global.get_arinaSala2Chapter() == 1:
	if information.dialog == "arina2_1":
		if information.answer == 0:
			smrt.stop() # We kindly ask SMRT to stop
			yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
			smrt.show_text("arinaSala2","arina2_2") # to finally follow it with a new dialog
			global.set_volatilidade(5)
			global.set_politeness(-5)
			#global.set_arinaSala2Chapter(2)
		elif information.answer == 1:
			smrt.stop() # We kindly ask SMRT to stop
			yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
			smrt.show_text("arinaSala2","arina2_2") # to finally follow it with a new dialog
			global.set_politeness(5)
			#global.set_arinaSala2Chapter(2)
		elif information.answer == 2:
			smrt.stop() # We kindly ask SMRT to stop
			yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
			smrt.show_text("arinaSala2","arina2_2") # to finally follow it with a new dialog
			global.set_entusiasmo(-5)
			global.set_compassion(-5)
			global.set_assertividade(-5)
		global.set_arinaSala2Chapter(2)

func _on_AreaHanaga_body_enter( body ):
	if body == char:
		canInteract = true
		area = "hanaga"


func _on_AreaFei_body_enter( body ):
	if body == char:
		canInteract = true
		area = "fei"


func _on_AreaArina_body_enter( body ):
	if body == char:
		canInteract = true
		area = "arina"



