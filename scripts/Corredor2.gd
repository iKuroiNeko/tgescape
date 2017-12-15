extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("Panel/TIE")
onready var panel = get_node ("Panel")
onready var msg = get_node("Message/Label")
onready var menu = get_node("Inventory/Panel/menu")
onready var smrt = get_node("Canvas/dialog")
onready var monster1 = get_node("Monsters/monster1")
onready var monster2 = get_node("Monsters/monster2")
onready var colar = get_node("Colar")
onready var colarArea = get_node("Areas/AreaColar")
onready var inventory = get_node("Inventory")
onready var timer = get_node("Timer")
var p = null

var isMonster = false
var canInteract = false
var whichMonster = null
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
var portaTrancada = true
var quadroAberto = false
var quadro = null
var quarto = null
var temPergunta 
var weapon = null
var isPlantaQuadro = false
var canHit = true
func _ready():
	set_process_input(true)
	array1 = global.get_itemArray()
	Inventory.updateItems()
	#posição inicial do player
	weapon = global.get_weapon()
	char.set_translation(global.get_charPos())
	if weapon != null:
		get_node("Haku/Armature/Skeleton/BoneAttachment/" + weapon).show()
		global.set_canHit(true)
	else:
		global.set_canHit(false)
	#if global.get_arinaSala1() or global.get_arinaCorredor1() == false:
	if global.get_arinaCorredor2() == false:
		get_node("Areas/AreaArina").queue_free()
		
	if global.get_feiColarCorredor4():
		if global.get_colarPicked() == false:
			colar.show()
		else:
			colarArea.queue_free()
	else: 
		colarArea.queue_free()
	
func _input(event):
	
	if event.is_action_pressed("actionButton") and quarto == null and pressArea and dialogavel and Inventory.inventoryAberto== false:
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
		global.set_qtdInteracoes()
		
	if event.is_action_pressed("actionButton") and quarto != null and pressArea and dialogavel:
		#verifChave(quarto)
		if texto != null:
			dialog(texto)
			pressArea = false
			global.set_qtdInteracoes()
			
	if event.is_action_pressed("actionButton") and global.temPergunta == true:
		print("Tem Pergunta")
	if event.is_action_pressed("hitButton") and isMonster:
  	 	whichMonster.getHit()
	if event.is_action_pressed("actionButton") and texto != null and isMonster and dialogavel:
		global.set_entusiasmo(5)
		global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and canInteract:
		canHit = false
		global.set_canMove(false)
		global.set_canInventory(false)
		if global.get_monsterPlantaChapter() == 1:
			smrt.show_text("MonsterPlanta", "text1")
			canInteract = false
		else: 
			smrt.show_text("MonsterPlanta","text5")
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

	if Input.is_action_pressed("actionButton") and buffEnd:
		tie.reset()
		panel.hide()
		dialogavel = true
		buffEnd = false
		global.canMove = true
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
	isMonster = false
	whichMonster = null
	isPlantaQuadro = false
	
func _on_AreaPlanta_body_enter( body ):
	if body == char:
		pressArea = true
		dialogavel = true
		texto = "Uma planta."
		isPlantaQuadro = true

func _on_AreaCorredor1_body_enter( body ):
	if body == char:
		Transition.fade_to("Corredor1.tscn")
		global.set_charPos(Vector3(15.908468,-1.53266,61.27647))


func _on_AreaHit_body_enter( body ):
	if body == char:	
		isMonster = true


func _on_AreaDanger_body_enter( body ):
	if body == char:
		if monster1.hit < 1:
			Transition.fade_to("Game.tscn")

			global.set_charPos(Vector3(16.5818,-3.0438,12.8958))


func _on_AreaTalk_body_enter( body ):
	if body == char:
		#dialogavel = true
		#pressArea = true
		canInteract = true
		area = "monsterPlanta"
		#texto = "Eu amo plantas."
		isMonster = true


func _on_AreaHitMonster1_body_enter( body ):
	if body == char:
		isMonster = true
		whichMonster = monster1

func _on_AreaHitMonster2_body_enter( body ):
	if body == char:
		isMonster = true
		whichMonster = monster2


func _on_AreaTalkMonster1_body_enter( body ):
	if body == char:
		whichMonster = monster1
		dialogavel = true
		pressArea = true
		texto = "Doeu :C"
		isMonster = true

func _on_AreaSala1_body_enter( body ):
	if body == char:
		Transition.fade_to("Sala1.tscn")
		#Transition.fade_to("Final.tscn")
		global.set_charPos(Vector3(34.202877, -3.906259, 19.577702))


func _on_dialog_finished():
	global.set_canMove(true)
	global.set_canInventory(true)
	global.set_canHit(true)

func _on_dialog_dialog_control( info ):
	global.set_canHit(false)
	canHit = false
	global.set_canMove(false)
	global.set_canInventory(false)
	#print(info.answer)
	if area == "monsterPlanta":
		if info.dialog == "text1":
			if info.answer == 0:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MonsterPlanta", "text2_1")
				global.set_openness(5)
				global.set_politeness(5)
				
			elif info.answer == 1:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MonsterPlanta", "text2_2")
				global.set_openness(-10)
				
			elif info.answer == 2: 
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MonsterPlanta", "text2_1")
				global.set_politeness(5)
		
		elif info.dialog == "text2_1":
			if info.answer == 0:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MonsterPlanta", "text3")
				global.set_entusiasmo(10)
				global.set_compassion(5)
			elif info.answer == 1:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MonsterPlanta", "text4")
				global.set_entusiasmo(-10)
				global.set_politeness(-10)
			elif info.answer == 2:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MonsterPlanta", "text3")
				global.set_retratacao(10)
				
		elif info.dialog == "text2_2":
			if info.answer == 0:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MonsterPlanta", "text3")
				global.set_entusiasmo(10)
				global.set_compassion(5)
				#global.set_monsterPlantaChapter(2)
			elif info.answer == 1:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MonsterPlanta", "text4")
				global.set_entusiasmo(-10)
				global.set_politeness(-10)
				#global.set_monsterPlantaChapter(2)
			elif info.answer == 2: 
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("MonsterPlanta", "text3")
				global.set_retratacao(10)
		global.set_monsterPlantaChapter(2)
		
	if info.chapter == "arinaMonster":
		if info.dialog == "text1":
			if info.answer == 0:
				global.set_politeness(-5)
				global.set_compassion(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("arinaMonster","text2_negative")
				global.set_feiSala1(false)
			elif info.answer == 1:
				global.set_politeness(5)
				global.set_compassion(5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("arinaMonster","text2_positive")
				get_node("Areas/AreaArina").queue_free()
				global.set_arinaCorredor2(false)
				if global.get_saidaTrancado() == false:
					global.set_arinaSaida(true)
					global.set_feiSaida(true)
				elif global.get_corredor4Trancado() == false:
					global.set_arinaSala3(true)
					global.set_feiSala3(true)
				elif global.get_corredor3Trancado() == false:
					global.set_arinaSala2(true)
					global.set_feiSala2(true)
				else:
					global.set_arinaSala1(true)
					global.set_feiSala1(true)
				#global.set_arinaSala1(true)
				
	if info.chapter == "feiColar":
		if info.dialog == "fei1":
			if info.answer == 0:
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiColar","fei2")

func _on_AreaArina_body_enter( body ):
	if body == char:
		#tirar
		#global.set_arinaCorredor1(true)
		area == "arina"
		#if global.get_arinaCorredor1():
		smrt.show_text("arinaMonster","text1")


func _on_AreaColar_body_enter( body ):
	if body == char:
		pressArea = true
		temItem = true
		item = colar
		#areaColar = get_node("Areas/AreaColar")

		
		
func pickItem(item):
	if item == colar:
		colar.hide()
		if global.get_feiAnswerNo():
			msg.set_text("Você pegou o item: Colar da Fei")
			msg.show()
			inventory.addItem("Colar da Fei")
			timer.start()
		else:
			smrt.show_text("feiColar","fei1")
			global.set_feiSala3(true)
			global.set_entregouColar(true)
		temItem = false
		global.set_colarPicked(true)
		

	colarArea.queue_free()
	
func _on_Timer_timeout():
	msg.hide()
