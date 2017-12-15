extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("Panel/TIE")
onready var panel = get_node ("Panel")
onready var msg = get_node("Message/Label")
#onready var inventory = get_node("Inventory")
onready var puzzles = get_node("Puzzles")
#onready var menu = get_node("Inventory/Panel/menu")
onready var bauPuzzle = get_node("Puzzles/BauPuzzle")
onready var armarioPuzzle = get_node("Puzzles/armario2Puzzle")
onready var expFei = get_node("Fei/Expression")
onready var fei = get_node("Fei")
onready var optionPanel = get_node("OptionPanel")
onready var optionFei1 = get_node("OptionPanel/Fei1")
onready var optionFei2 = get_node("OptionPanel/Fei2")
onready var areaTriggerFei = get_node("Areas/AreaTriggerFei")
onready var smrt = get_node("Canvas/dialog")
onready var hanaga = get_node("Hanaga")
onready var arina = get_node("arina")
var chatAnswer = null

var chapterFei = "firstEncounterFei"
var dialog
var myText
var myDialog

var isPlantaQuadro = false

var dialogQuestion = false
var p = null
var i = 0
var texto = null
var pressArea = false
var dialogavel = false
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
var quadroAberto = false
var quadro = null
var quarto = null
var temPergunta 
var weapon = null
var charChat = false
var canShowPanel = false
var canInteract = false

var seconds = 0
var elapsed = 0
var time_now = 0
var time_start = OS.get_unix_time()

var hanagaTrancado 
var arinaTrancada 

func _ready():
	set_process_input(true)
	hanagaTrancado = global.get_hanagaTrancado()
	arinaTrancada = global.get_arinaTrancada()
	array1 = global.get_itemArray()
	portaTrancada = global.get_corredor2Trancado()
	Inventory.updateItems()
	#posição inicial do player
	weapon = global.get_weapon()
	char.set_translation(global.get_charPos())
	if weapon != null:
		get_node("Haku/Armature/Skeleton/BoneAttachment/" + weapon).show()
		global.set_canHit(true)
	else:
		global.set_canHit(false)
		
	
	
	if global.get_areaTriggerFei() == false:
		areaTriggerFei.queue_free()
	
	if global.get_feiCorredor1() == false:
		get_node("Fei").queue_free()
	
	if global.get_passAreaC1():
		get_node("Areas/AreaCorredorTriggerFei").queue_free()
	
	if global.get_hanagaCorredor1():
		#if global.get_hanagaTrancado() == false:
		hanaga.show()
		global.set_hanagaSala1(true)
			#global.set_hanagaCorredor1(false)
	else:
		get_node("Hanaga").queue_free()
		
	if global.get_arinaCorredor1() == false:
		get_node("arina").queue_free()
	else:
		#get_node("arina").queue_free()
		arina.show()
		fei.set_translation(Vector3(1.40,-1.41,45.87))
		fei.set_rotation_deg(Vector3(0,90,0))
		#global.set_arinaSala1(true)
		global.set_arinaCorredor2(true)
		#global.set_arinaCorredor1(false)
	
	#if global.get_arinaCorredor1() and global.get_hanagaCorredor1():
	if global.get_arinaTrancada() == false and global.get_hanagaTrancado() == false:
		if global.get_saidaTrancado() == false:
			global.set_feiSaida(true)
		elif global.get_corredor4Trancado() == false:
			global.set_feiSala3(true)
		elif global.get_corredor3Trancado() == false:
			global.set_feiSala2(true)
		else:
			global.set_feiSala1(true)
		#global.set_feiCorredor1(false)
	
	if global.get_areaQuadros() == false:
		get_node("Areas/AreaQuadro Yellow").queue_free()
		get_node("Areas/AreaQuadroRed").queue_free()
		get_node("Areas/AreaQuadroGreen").queue_free()
		get_node("Areas/AreaQuadroBlue").queue_free()
		
func _process(delta):
	seconds = 0
	elapsed = 0
	time_now = OS.get_unix_time()
	elapsed = time_now - time_start
	seconds = elapsed
	print("elapsed : ", seconds)

func _input(event):
	
	if event.is_action_pressed("actionButton") and quarto == null and pressArea and dialogavel and Inventory.inventoryAberto== false:
		global.set_canHit(false)
		global.set_canMove(false)
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
		dialogavel = false
		p.openPuzzle()
		pressArea = false
		global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and pressArea and quadro != null and quadroAberto:
		get_node("Puzzles/" + quadro).show()
		#quadroAberto = true
		global.canMove = false
		global.set_canHit(false)
		global.set_canInventory(false)
		global.set_qtdInteracoes()
		time_start = OS.get_unix_time()
		set_process(true)
	if event.is_action_pressed("cancelButton") and quadroAberto:
		closeQuadro()
		quadroAberto = set_process(false)
		global.set_puzzleTime(elapsed)
		global.set_canHit(true)
		global.set_canInventory(true)
#	if event.is_action_pressed("actionButton") and quarto != null and pressArea and dialogavel:
#		verifChave(quarto)
#		if texto != null:
#			dialog(texto)
#			dialogavel = false
#			pressArea = false
	if event.is_action_pressed("actionButton") and dialogQuestion and canInteract:
		global.set_canHit(false)
		if area == "fei":
			if global.get_feiChapter() == 1:
				smrt.show_text("firstEncounterFei","Text")
				
			elif global.get_feiChapter() == 2 or global.get_feiChapter() == 3:
				smrt.show_text("Fei1","Text")
		
			elif global.get_feiChapter() == 4 and global.get_arinaCorredor1():
				smrt.show_text("Fei1","textArina")
			elif global.get_feiChapter() == 4 and global.get_arinaCorredor1() == false:
				smrt.show_text("Fei1","textNotArina")
			
			elif global.get_feiChapter() == 5 and global.get_arinaCorredor1() == false:
				smrt.show_text("Fei1","text2")
			elif global.get_feiChapter() == 5 and global.get_arinaCorredor1():
				smrt.show_text("Fei1","textArina")
				
			########### HANAGA #############
		elif area == "hanaga" and global.get_hanagaTrancado():
			if global.get_hanagaChapter() == 1:
				smrt.show_text("hanagaTrancado","locked1")
				print("Locked1")
			elif global.get_hanagaChapter() == 2:
				smrt.show_text("hanagaTrancado","noKey")
			
			elif global.get_hanagaChapter() == 3:
				smrt.show_text("hanagaTrancado","unlock")
		elif area == "hanaga" and global.get_hanagaTrancado() == false:
			if global.get_hanagaChapter() == 5:
				smrt.show_text("hanagaCorredor1","text1")
				
				#######  ARINA ##########
		elif area == "arina" and global.get_arinaTrancada():
			if global.get_arinaChapter() == 1:
				smrt.show_text("arinaTrancada","locked1")
			
			elif global.get_arinaChapter() == 2:
				smrt.show_text("arinaTrancada","noKey")
			
			elif global.get_arinaChapter() == 3:
				smrt.show_text("arinaTrancada","unlock")
#			elif global.get_arinaChapter() == 5:
#				smrt.show_text("arinaCorredor1","text")
		elif area == "arina" and global.get_arinaTrancada() == false:
			if global.get_arinaChapter() == 5:
				smrt.show_text("arinaCorredor1","text")
				
		global.set_canMove(false)
		canInteract = false
		global.set_canInventory(false)
		
		
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
	pressArea = true
	#global.set_respondeu(true)
	
	
	if Input.is_action_pressed("actionButton") and buffEnd:
		tie.reset()
		panel.hide()
		dialogavel = true
		buffEnd = false
		global.set_canMove(true)
		global.set_canInventory(true)
		global.set_canHit(true)
		
func _on_Area_body_exit( body ):
	pressArea = false
	dialogavel = false
	temPuzzle = false
	quadroAberto = false
	quadro = null
	quarto = null
	p = null
	texto = null
	temPergunta = false
	global.set_temPergunta(false)
	chatAnswer = null
	dialogQuestion = false
	charChat = false
	isPlantaQuadro = false
	area = null
	canInteract = false
	
func _on_AreaItem_body_exit( body ):
	temItem = false
	item = null
	area = null
	

func _on_AreaQuarto1_body_enter( body ):
	if body == char:
		Transition.fade_to("Game.tscn")
		global.set_charPos(Vector3(16.581829,-3.47173,12.895826))

func closeQuadro():
	if quadroAberto:
		puzzles.get_node(quadro).hide()
		global.canMove = true


func _on_AreaBau_body_enter( body ):
	if body == char:
		pressArea = true
		p = bauPuzzle
		temPuzzle = true


func _on_AreaArmario_body_enter( body ):
	if body == char:
		pressArea = true
		p = armarioPuzzle
		temPuzzle = true
		global.set_temPergunta(true)
		
func _on_AreaQuadroRed_body_enter( body ):
	if body == char:
		quadroAberto = true
		pressArea = true
		quadro = "QuadroRed"
	

func _on_AreaQuadro_Yellow_body_enter( body ):
	if body == char:
		quadroAberto = true
		pressArea = true
		quadro = "QuadroYellow"

func _on_AreaQuadroGreen_body_enter( body ):
	if body == char:
		quadroAberto = true
		pressArea = true
		quadro ="QuadroGreen"


func _on_AreaQuadroBlue_body_enter( body ):
	if body == char:
		quadroAberto = true
		pressArea = true
		quadro = "QuadroBlue"

func _on_AreaPlanta_body_enter( body ):
	if body == char:
		pressArea = true
		dialogavel = true
		texto = "Uma planta."
		isPlantaQuadro = true

func _on_AreaTriggerFei_body_enter( body ):
	if body == char:
		expFei.expressions("exclamation")
		get_node("Areas/AreaTriggerFei").queue_free()
		global.set_otherCharWalk(true)
		fei.walk()
		global.set_areaTriggerFei(false)
		
func _on_AreaQuarto2_body_enter( body ):
	if body == char:
		#dialogavel = true
		#pressArea = true
		quarto = "Quarto2"
		#texto = dict.hanagaTrancado
		verifChave(quarto)
		area = "hanaga"
		canInteract = true
		dialogQuestion = true
		
func _on_AreaQuarto3_body_enter( body ):
	if body == char:
		#dialogavel = true
		#pressArea = true
		quarto = "Quarto3"
		#texto = dict.arinaTrancada
		verifChave(quarto)
		area = "arina"
		canInteract = true
		dialogQuestion = true
		
func _on_AreaPortaCorredor_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		quarto = "Corredor2"
		#texto = "Tá trancado"
		verifChave(quarto)
		#for i in range(0, array1.size()):
		#	if array1[i] == "Chave do Corredor":
		#		global.set_corredor2Trancado(false)
		#		array1.remove(i)
		#		break

func _on_AreaQuarto4_body_enter( body ):
	if body == char:
		Transition.fade_to("Quarto4.tscn")
		global.set_charPos(Vector3(14,-0.15,12))

func verifChave(quarto):
	array1 = global.get_itemArray()
	
	if quarto == "Quarto2":
		if global.get_quarto2Trancado():
			for i in range(0, array1.size()):
				if array1[i] == "Chave do quarto dois":
					temChave = true
					global.set_hanagaChapter(3)
					break
			
		elif global.get_quarto2Trancado() == false:
			Transition.fade_to("Quarto2.tscn")
			global.set_charPos(Vector3(18.110, -2.915, 14.790))
	
	if quarto == "Quarto3":
		if global.get_quarto3Trancado():
			for i in range(0, array1.size()):
				if array1[i] == "Chave do quarto tres":
					temChave = true
					global.set_arinaChapter(3)
					break
				
		
		elif global.get_quarto3Trancado() == false:
			Transition.fade_to("Quarto3.tscn")
			global.set_charPos(Vector3(16.14, -0.13, 11.65))
	
	if quarto == "Corredor2":
		if global.get_corredor2Trancado():
			for c in range(0, array1.size()):
				if array1[c] == "Chave do Corredor":
					temChave = true
					print("destranquei")
					portaTrancada = false
					if global.get_passAreaC1():
						if global.get_answeredC1():
							if global.get_answerHelp():
								if global.get_hanagaTrancado() == false and global.get_arinaTrancada() == false: 
									Transition.fade_to("Corredor2.tscn")
									global.set_charPos(Vector3(65.760841,-1.72326,0))
									global.set_hanagaCorredor1(false) 
									global.set_arinaCorredor1(false)
									global.set_feiCorredor1(false)
									for i in range(0, array1.size()):
										if array1[i] == "Chave do Corredor":
											global.set_corredor2Trancado(false)
											array1.remove(i)
											break
								else:
									dialog("Tenho que ajudar todos primeiro!")
							else:
								Transition.fade_to("Corredor2.tscn")
								for i in range(0, array1.size()):
									if array1[i] == "Chave do Corredor":
										global.set_corredor2Trancado(false)
										array1.remove(i)
										break
								global.set_charPos(Vector3(65.760841,-1.72326,0))
								if global.get_hanagaTrancado() == false:
									global.set_hanagaCorredor1(false) 
								if global.get_arinaTrancada() == false:
									global.set_arinaCorredor1(false)
								if global.get_hanagaTrancado() == false and global.get_arinaTrancada() == false:
									global.set_feiCorredor1(false)
					elif global.get_answeredC1() == false:
						if global.get_hanagaTrancado() == false and global.get_arinaTrancada() == false: 
							Transition.fade_to("Corredor2.tscn")
							global.set_charPos(Vector3(65.760841,-1.72326,0))
							global.set_hanagaCorredor1(false) 
							global.set_arinaCorredor1(false)
							global.set_feiCorredor1(false)
							for i in range(0, array1.size()):
								if array1[i] == "Chave do Corredor":
									global.set_corredor2Trancado(false)
									array1.remove(i)
									break
					break
				
			if portaTrancada:
				dialog("Tá trancado.")
		elif global.get_corredor2Trancado() == false:
			if global.get_passAreaC1():
				if global.get_answeredC1():
					if global.get_answerHelp():
						if global.get_hanagaTrancado() == false and global.get_arinaTrancada() == false: 
							Transition.fade_to("Corredor2.tscn")
							global.set_charPos(Vector3(65.760841,-1.72326,0))
							global.set_hanagaCorredor1(false) 
							global.set_arinaCorredor1(false)
							global.set_feiCorredor1(false)
						else:
							dialog("Tenho que ajudar todos primeiro!")
					else:
						Transition.fade_to("Corredor2.tscn")
						global.set_charPos(Vector3(65.760841,-1.72326,0))
						if global.get_hanagaTrancado() == false:
							global.set_hanagaCorredor1(false) 
						if global.get_arinaTrancada() == false:
							global.set_arinaCorredor1(false)
						if global.get_hanagaTrancado() == false and global.get_arinaTrancada() == false:
							global.set_feiCorredor1(false)
			elif global.get_answeredC1() == false:
				if global.get_hanagaTrancado() == false and global.get_arinaTrancada() == false: 
					Transition.fade_to("Corredor2.tscn")
					global.set_charPos(Vector3(65.760841,-1.72326,0))
					global.set_hanagaCorredor1(false) 
					global.set_arinaCorredor1(false)
					global.set_feiCorredor1(false)

func _on_AreaFei_body_enter( body ):
	if body == char: 
		charChat = true
		pressArea = true
		dialogQuestion = true
		canInteract = true
		area = "fei"

func _on_dialog_dialog_control( information ):
	global.set_canMove(false)
	global.set_canInventory(false)
	global.set_canHit(false)
	#if chapterFei == "firstEncounterFei":
	if information.chapter == "firstEncounterFei":
		if information.dialog == "Text":
			if information.answer == 0:
				smrt.stop() # We kindly ask SMRT to stop
				yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
				smrt.show_text("firstEncounterFei","Fei2") # to finally follow it with a new dialog
				global.set_politeness(5)
				
			if information.answer == 1:
				smrt.stop() # We kindly ask SMRT to stop
				yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
				smrt.show_text("firstEncounterFei","Fei2") # to finally follow it with a new dialog
				global.set_volatilidade(5)
				
					
			elif information.answer == 2:
				smrt.stop() # We kindly ask SMRT to stop
				yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
				smrt.show_text("firstEncounterFei","Fei3") # to finally follow it with a new dialog
				global.set_retratacao(5)
		if information.dialog == "Fei2":
			if information.answer == 0:
				smrt.stop() # We kindly ask SMRT to stop
				yield(get_tree(),"idle_frame") # and wait one frame for it to patch things up and quit nicelly
				smrt.show_text("firstEncounterFei","Fei4_positive") # to finally follow it with a new dialog
				yield(smrt,"finished")
				if information.last_text_index == information.total_text:
					global.set_canMove(true)
					global.set_feiChapter(2)
					global.set_politeness(5)
			elif information.answer == 1:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("firstEncounterFei","Fei4_negative")
				yield(smrt,"finished")
				if information.last_text_index == information.total_text:
					global.set_canMove(true)
					global.set_feiChapter(2)
					global.set_politeness(-5)
					global.set_entusiasmo(-5)
		
		if information.dialog == "Fei3":
			if information.answer == 0:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("firstEncounterFei","Fei4_positive") 
				yield(smrt,"finished")
				if information.last_text_index == information.total_text:
					global.set_canMove(true)
					global.set_feiChapter(2)
					global.set_politeness(5)
			elif information.answer == 1:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("firstEncounterFei","Fei4_negative") 
				#yield(smrt,"finished")
				if information.last_text_index == information.total_text:
					global.set_canMove(true)
					global.set_feiChapter(2)
					global.set_politeness(-5)
					global.set_entusiasmo(-5)
	
	if information.chapter == "FeiWorried":
		if information.dialog == "text1":
			if information.answer == 0:
				global.set_compassion(5)
				global.set_entusiasmo(5)
				global.set_assertividade(5)
				global.set_politeness(5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("FeiWorried","text2_positive")
				global.set_feiChapter(4)
				global.set_answerHelp(true)
				global.set_answeredC1(true)
				for i in range(0, array1.size()):
					if array1[i] == "Chave do Corredor":
						global.set_corredor2Trancado(false)
						array1.remove(i)
						break
			elif information.answer == 1:
				global.set_compassion(-10)
				global.set_entusiasmo(-5)
				global.set_politeness(-5)
				global.set_feiChapter(5)
				global.set_answeredC1(true)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("FeiWorried","text2_negative")
				global.set_corredor2Trancado(false)
				for i in range(0, array1.size()):
					if array1[i] == "Chave do Corredor":
						global.set_corredor2Trancado(false)
						array1.remove(i)
						break
						
	#### HANAGA #######
	elif global.get_hanagaChapter() == 1:
		print("chapter 1")
		if information.chapter == "hanagaTrancado":
			if information.dialog == "locked1":
				if information.answer == 0:
					smrt.stop()
					yield(get_tree(),"idle_frame")
					smrt.show_text("hanagaTrancado","locked2")
					print("locked2")
			if information.dialog == "locked2":
				if information.answer == 0:
					global.set_politeness(5)
					global.set_compassion(5)
					global.set_hanagaChapter(2)
					smrt.stop()
					yield(get_tree(),"idle_frame")
					smrt.show_text("hanagaTrancado","noKey")
				elif information.answer == 1:
					global.set_volatilidade(5)
					global.set_hanagaChapter(2)
					smrt.stop()
					yield(get_tree(),"idle_frame")
					smrt.show_text("hanagaTrancado","noKey")
				elif information.answer == 2:
					global.set_assertividade(-5)
					global.set_hanagaChapter(2)
					smrt.stop()
					yield(get_tree(),"idle_frame")
					smrt.show_text("hanagaTrancado","noKey")
				
	if global.get_hanagaChapter() == 3:
		if information.chapter == "hanagaTrancado":
			print("chapter 3")
			if information.dialog == "unlock":
				if information.answer == 0:
					global.set_hanagaTrancado(false)
					global.set_retratacao(-5)
					global.set_compassion(10)
					global.set_quarto2Trancado(false)
					Transition.fade_to("Quarto2.tscn")
					global.set_charPos(Vector3(18.110, -2.915, 14.790))
					global.set_hanagaChapter(4)
					print("destranquei hanaga")
					for i in range (0, array1.size()):
						if array1[i] == "Chave do quarto dois":
							array1.remove(i)
							Inventory.updateItems()
							break
							
				elif information.answer == 1:
					global.set_retratacao(5)
					
	##### ARINA #########
	elif global.get_arinaChapter() == 1:
		if information.chapter == "arinaTrancada":
			if information.dialog == "locked1":
				if information.answer == 0:
					smrt.stop()
					yield(get_tree(),"idle_frame")
					smrt.show_text("arinaTrancada","locked2")
		
			if information.dialog == "locked2":
				print("locked2")
				if information.answer == 0:
					global.set_politeness(5)
					global.set_compassion(5)
					global.set_arinaChapter(2)
					print("answer 1")
					smrt.stop()
					yield(get_tree(),"idle_frame")
					smrt.show_text("arinaTrancada","noKey")
				elif information.answer == 1:
					global.set_volatilidade(5)
					global.set_arinaChapter(2)
					smrt.stop()
					yield(get_tree(),"idle_frame")
					smrt.show_text("arinaTrancada","noKey")
				elif information.answer == 2:
					smrt.stop()
					yield(get_tree(),"idle_frame")
					smrt.show_text("arinaTrancada","noKey")
					global.set_assertividade(-5)
					global.set_arinaChapter(2)
				
				
	if global.get_arinaChapter() == 3:
		if information.chapter == "arinaTrancada":
			print("chapter 3")
			if information.dialog == "unlock":
				if information.answer == 0:
					global.set_compassion(10)
					global.set_arinaTrancada(false)
					global.set_retratacao(-5)
					portaTrancada = false
					global.set_quarto3Trancado(portaTrancada)
					Transition.fade_to("Quarto3.tscn")
					global.set_charPos(Vector3(16.14, -0.13, 11.65))
					global.set_arinaChapter(4)
					print("destranquei arina")
					for i in range (0, array1.size()):
						if array1[i] == "Chave do quarto tres":
							array1.remove(i)
							Inventory.updateItems()
							break
				elif information.answer == 1:
					global.set_retratacao(5)
	
				
func _on_dialog_finished():
	global.set_canMove(true)
	global.set_canInventory(true)
	global.set_canHit(true)

func _on_AreaHanaga_body_enter( body ):
	if body == char:
		charChat = true
		pressArea = true
		dialogQuestion = true
		canInteract = true
		area = "hanaga"


func _on_AreaCorredorTriggerFei_body_enter( body ):
	if body == char:
		if global.get_feiChapter() == 4 or global.get_feiChapter() == 3:
			if global.get_hanagaTrancado() or global.get_arinaTrancada():
				global.set_canMove(false)
				global.set_canInventory(false)
				smrt.show_text("FeiWorried","text1")
				get_node("Fei").set_rotation_deg(Vector3(0,0,0))
				global.set_passAreaC1(true)
				get_node("Areas/AreaCorredorTriggerFei").queue_free()


func _on_AreaArina_body_enter( body ):
	if body == char:
		charChat = true
		pressArea = true
		dialogQuestion = true
		canInteract = true
		area = "arina"
