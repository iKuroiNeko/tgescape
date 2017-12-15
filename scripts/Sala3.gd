extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("DialogPanel/TIE")
onready var panel = get_node ("DialogPanel")
onready var msg = get_node("Message/Label")
onready var puzzlePaper = get_node("sala3/papelPuzzle")
#onready var puzzlePenDrive = get_node("sala1/penDrive")
onready var inventory = get_node("Inventory")
onready var puzzles = get_node("Puzzles")
onready var menu = get_node("Inventory/Panel/menu")
onready var armarioPuzzle = get_node("Puzzles/puzzleArmario1Sala3")
onready var armarioPuzzle2 = get_node("Puzzles/puzzleArmario2Sala3")
onready var parede = get_node("Puzzles/parede")
onready var piano = get_node("Puzzles/piano")
onready var telaVerde = get_node("Puzzles/puzzleSenha")
onready var areaCaixa = get_node("Areas/AreaCaixas")
#onready var anim = get_node("AnimationPlayer")
onready var boneAtt = get_node("Haku/Armature/Skeleton/BoneAttachment" )
onready var timer = get_node("Timer")
onready var smrt = get_node("Canvas/dialog")

onready var hanaga = get_node("Hanaga")
onready var hanagaExp = get_node("Hanaga/Expression")

onready var fei = get_node("Fei")
onready var feiExp = get_node("Fei/Expression")

onready var arina = get_node("arina")
onready var arinaExp = get_node("arina/Expression")


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
var caixaInteract = false
var array1 = []
var portaTrancada
var isPlantaQuadro = false
#var pdPicked
var paperPicked
var canInteract = false

var dict = {
textQuadro = "Que criatura é essa?",
textCama = "Uma cama, eu acordei nela.",
textMesa = "Tem documentos... sobre mim? \nQue lugar é esse?",
textPorta = "A porta está trancada, não consigo sair..."
}

func _ready():
	
	set_process_input(true)
	array1 = global.get_itemArray()
	inventory.updateItems()
	portaTrancada = global.get_corredor4Trancado()
	paperPicked = global.get_paperPickedS3()
	
	#global.set_arinaSala3(true)
	#global.set_hanagaSala3(true)
	#global.set_feiSala3(true)

	if paperPicked:
		puzzlePaper.hide()
		temItem = false
		get_node("Areas/AreaPapel").queue_free()
	
	weapon = global.get_weapon()
	
		
	#posição inicial do player
	char.set_translation(global.get_charPos())
	if weapon != null:
		get_node("Haku/Armature/Skeleton/BoneAttachment/" + weapon).show()
		global.set_canHit(true)
	else:
		global.set_canHit(false)
		
	if global.get_hanagaSala3():
		areaCaixa.queue_free()
		hanaga.show()
	else:
		hanaga.queue_free()
		
	if global.get_feiSala3():
		fei.show()
	else:
		fei.queue_free()
	
	if global.get_arinaSala3():
		arina.show()
	else:
		arina.queue_free()
	
func _input(event):

	if event.is_action_pressed("actionButton") and pressArea and dialogavel and inventory.inventoryAberto== false:
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
	if event.is_action_pressed("actionButton") and pressArea and caixaInteract:
		caixaItem()
		caixaInteract = false
		
	if event.is_action_pressed("actionButton") and temPuzzle and pressArea:
		p.openPuzzle()
	if event.is_action_pressed("actionButton") and pressArea and temChave == false:
		if texto != null:
			dialog(texto)
			dialogavel = false
	
	if event.is_action_pressed("actionButton") and canInteract:
		#global.set_canMove(false)
		#global.set_canInventory(false)
		#### FEI #######################################
		if area == "fei":
			if global.get_feiSala3Chapter() == 1:
				smrt.show_text("feiSala3","fei3_1")
				
			elif global.get_feiSala3Chapter() == 2:
				smrt.show_text("feiSala3","fei3_2")
			########### HANAGA #############
		elif area == "hanaga":
			if global.get_hanagaSala3Chapter() == 1:
				smrt.show_text("hanagaSala3","hanaga3_1")
				
			elif global.get_hanagaSala3Chapter() == 2:
				#hanagaExp.expressions("swearing")
				smrt.show_text("hanagaSala3","hanaga3_5")
				#######  ARINA ##########
		elif area == "arina":
			if global.get_arinaSala3Chapter() == 1:
				smrt.show_text("arinaSala3","arina3_1")

			elif global.get_arinaSala3Chapter() == 2:
				smrt.show_text("arinaSala3","arina3_3")

		global.set_canMove(false)
		global.set_canInventory(false)
		canInteract = false

func _on_AreaQuadro_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "Isso é um...\nPeixe...\nGato...?"
		isPlantaQuadro = true

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
	#img = null
	area = null
	isPlantaQuadro = false

func _on_AreaMesa_body_enter( body ):
	if body == char:
		pressArea = true
		caixaInteract = true

func caixaItem():
	if global.get_caixaParafuso() == false:
		if global.get_puzzleArmario2Sala3Res():
			dialogavel = true
			texto = "Consegui abrir a caixa, tem um papel aqui dentro."
			array1 = global.get_itemArray()
			global.set_caixaParafuso(true)
			for i in range(0, array1.size()):
				print(array1[i])
				if array1[i] == "Chave de fenda":
					array1.remove(i)
					break
			inventory.updateItems()
			inventory.addItem("Papel com desenhos")
		else:
			dialogavel = true
			texto = "Essa caixa está parafusada..."
	elif global.get_caixaParafuso():
		dialogavel = true
		pressArea = true
		texto = "Não tem mais nada dentro da caixa."


func pickItem(item):
	if item == puzzlePaper:
		puzzlePaper.hide()
		msg.show()
		msg.set_text("Você pegou o item: Papel com números")
		temItem = false
		inventory.addItem("Papel com números")
		global.set_paperPickedS3(true)
		timer.start()
	
	area.queue_free()


#func _on_AreaPuzzle1_body_enter( body ):
#	if body == char:
#		temItem = true
#		item = "Papel estranho"
#		area = "Areas/AreaPuzzle1"
#		puzzleNode = get_node("FirstRoom/papelPuzzle1")
	
func _on_AreaItem_body_exit( body ):
	temItem = false
	item = null
	area = null

func _on_Timer_timeout():
	msg.hide()

func _on_AreaArmario1_body_enter( body ):
	if body == char: 
		temPuzzle = true
		pressArea = true
		p = armarioPuzzle

func _on_AreaArmario2_body_enter( body ):
	if body == char: 
		temPuzzle = true
		pressArea = true
		p = armarioPuzzle2

func _on_AreaPlanta_body_enter( body ):
	if body == char:
		texto = "Uma planta."
		dialogavel = true
		pressArea = true
		isPlantaQuadro = true

func _on_AreaMonitor_body_enter( body ):
	if body == char:
		temPuzzle = true
		pressArea = true
		p = telaVerde

func _on_AreaPapel_body_enter( body ):
	if body == char:
		pressArea = true
		temItem = true
		item = puzzlePaper
		area = get_node("Areas/AreaPapel")

func _on_AreaPorta1_body_enter( body ):
	if body == char:
		Transition.fade_to("Corredor4.tscn")
		global.set_charPos(Vector3(-33,-1.5,3))

func _on_AreaPorta2_body_enter( body ):
	if body == char:
		if global.get_saidaTrancado():
			pressArea = true
			dialogavel = true
			texto = "Tá trancado..."
		else:
			Transition.fade_to("Saida.tscn")
			global.set_charPos(Vector3(-33,0.8,0))
#			
#			if global.get_passCorredor4() == false:
#				global.set_arinaSaida(global.get_arinaSala3())
#				global.set_feiSaida(global.get_feiSala3())
#				global.set_hanagaSaida(global.get_hanagaSala3())
#				global.set_arinaSala3(false)
#				global.set_feiSala3(false)
#				global.set_hanagaSala3(false)
#				global.set_passSaida(true)
			if global.get_hanagaSala3():
				global.set_hanagaSaida(true)
				global.set_hanagaSala3(false)
			if global.get_arinaSala3():
				global.set_arinaSaida(true)
				global.set_arinaSala3(false)
			if global.get_feiSala3():
				global.set_feiSaida(true)
				global.set_feiSala3(false)


func _on_AreaPiano_body_enter( body ):
	if body == char: 
		temPuzzle = true
		pressArea = true
		p = piano

func _on_AreaCaixas_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "Caixas... Nada de útil nelas..."

func _on_AreaParede_body_enter( body ):
	if body == char: 
		temPuzzle = true
		pressArea = true
		p = parede

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


func _on_dialog_dialog_control( information ):
	global.set_canMove(false)
	global.set_canInventory(false)
	global.set_canHit(false)
	if information.dialog == "fei3_1":
		if information.answer == 0: #depois penso
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("feiSala3","fei3_2") 
			global.set_dedicacao(-10)
		elif information.answer == 1: #ahhhh não 
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("feiSala3","fei3_2")
			global.set_intelecto(-10)
		elif information.answer == 2: #talvez use depois
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("feiSala3","fei3_2") 
		elif information.answer == 3: #já sei o que é
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("feiSala3","fei3_2") 
			global.set_intelecto(10)
		global.set_feiSala3Chapter(2)
	
	#### HANAGA #######
	#elif global.get_hanagaSala2Chapter() == 1:
	if information.dialog == "hanaga3_1": 
		if information.answer == 0: #você ta vendo não
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_2") 
			global.set_volatilidade(5)
			global.set_politeness(-5)
			global.set_compassion(-5)
			#global.set_hanagaSala2Chapter(2)
		elif information.answer == 1: #não sei
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_2") 
			global.set_assertividade(-5)
			#global.set_hanagaSala2Chapter(2)
		elif information.answer == 2: #são caixas
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_2") 
			global.set_politeness(5)
			global.set_volatilidade(-5)
			
	elif information.dialog == "hanaga3_2": 
		if information.answer == 0: #hmm são caixas
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_3") 
			global.set_politeness(5)
			global.set_volatilidade(-5)
			#global.set_hanagaSala2Chapter(2)
		elif information.answer == 1: #acho que estão enfeitando as salas
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_3") 
			global.set_politeness(5)
			global.set_volatilidade(-5)
			#global.set_hanagaSala2Chapter(2)
		elif information.answer == 2: #não sei também
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_3") 
		elif information.answer == 3: #vou saber
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_3") 
			global.set_volatilidade(5)
			global.set_politeness(-5)
	elif information.dialog == "hanaga3_3": 
		if information.answer == 0: #voce nem sabia
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_4") 
			global.set_volatilidade(5)
			global.set_politeness(-5)
			global.set_compassion(-5)
			#global.set_hanagaSala2Chapter(2)
		elif information.answer == 1: #ja disse que naaao
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_4") 
			global.set_volatilidade(5)
			#global.set_hanagaSala2Chapter(2)
		elif information.answer == 2: #não ;u;
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_4") 
			global.set_politeness(5)
		elif information.answer == 3: #ignorar
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("hanagaSala3","hanaga3_4") 
			global.set_compassion(-5)
			global.set_entusiasmo(-5)
			
		global.set_hanagaSala3Chapter(2)
	
	##### ARINA #########
	#elif global.get_arinaSala2Chapter() == 1:
	if information.dialog == "arina3_1": 
		if information.answer == 0: #não sei
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("arinaSala3","arina3_2") 
		elif information.answer == 1: #espero que sim
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("arinaSala3","arina3_2") 
			global.set_politeness(5)
		elif information.answer == 2: #mas como reclamaaa
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("arinaSala3","arina3_2") 
			global.set_volatilidade(5)
			global.set_politeness(-5)
			global.set_compassion(-5)
		elif information.answer == 3: #...
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("arinaSala3","arina3_2") 
			global.set_entusiasmo(-5)
			global.set_assertividade(-5)
			
	elif information.dialog == "arina3_2": 
		if information.answer == 0: #também quero ;3;
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("arinaSala3","arina3_3") 
			global.set_retratacao(5)
		elif information.answer == 1: #não é só você u3u
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("arinaSala3","arina3_3") 
			global.set_volatilidade(5)
		elif information.answer == 2: #vamos conseguir
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("arinaSala3","arina3_3") 
			global.set_politeness(5)
			global.set_compassion(5)
			global.set_retratacao(-5)
		elif information.answer == 3: #ignorar
			smrt.stop() 
			yield(get_tree(),"idle_frame") 
			smrt.show_text("arinaSala3","arina3_3") 
			global.set_entusiasmo(-5)
			global.set_assertividade(-5)
			global.set_compassion(-5)
			
		global.set_arinaSala3Chapter(2)


func _on_dialog_finished():
	global.set_canMove(true)
	global.set_canInventory(true)
	global.set_canHit(true)