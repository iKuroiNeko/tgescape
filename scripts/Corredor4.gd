extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("Panel/TIE")
onready var panel = get_node ("Panel")
onready var inventory = get_node("Inventory")
onready var menu = get_node("Inventory/Panel/menu")
#onready var monster1 = get_node("Monsters/monster1")
onready var monster2 = get_node("Monsters/monster2")
onready var feiAreaDialogo = get_node("Areas/AreaFeiDialogo")
onready var areaVerifica = get_node("Areas/AreaVerifica")
onready var smrt = get_node("Canvas/dialog")
var p = null

var isMonster = false

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

func _ready():
	set_process_input(true)
	array1 = global.get_itemArray()
	inventory.updateItems()
	#posição inicial do player
	weapon = global.get_weapon()
	char.set_translation(global.get_charPos())
	if weapon != null:
		get_node("Haku/Armature/Skeleton/BoneAttachment/" + weapon).show()
		global.set_canHit(true)
	else:
		global.set_canHit(false)
		
	if global.get_feiColarCorredor4() or global.get_feiSala3() == false:
	#if global.get_feiColarCorredor4():
		feiAreaDialogo.queue_free()
		
	
func _input(event):
	if event.is_action_pressed("hitButton") and char.move == false:
		char.playHit()
	if event.is_action_pressed("actionButton") and quarto == null and pressArea and dialogavel and inventory.inventoryAberto== false:
		if texto != null:
			dialog(texto)
			global.set_canMove(false)
			dialogavel = false
			if isMonster:
				global.set_entusiasmo(5)
				global.set_politeness(5)
			if isPlantaQuadro:
				global.set_openness(5)
	if event.is_action_pressed("actionButton") and !dialogavel and buffEnd:
		_on_TIE_buff_end()
	if event.is_action_pressed("actionButton") and temItem:
		if item != null:
			pickItem(item)
	if event.is_action_pressed("actionButton") and temPuzzle and pressArea:
		p.openPuzzle()
	if event.is_action_pressed("actionButton") and pressArea and quadro != null and quadroAberto == false:
		get_node("Puzzles/" + quadro).show()
		quadroAberto = true
		global.canMove = false
	if event.is_action_pressed("cancelButton") and quadroAberto:
		closeQuadro()
		quadroAberto = false
	if event.is_action_pressed("actionButton") and quarto != null and pressArea and dialogavel:
		#verifChave(quarto)
		if texto != null:
			dialog(texto)
			pressArea = false
			dialogavel = false
	if event.is_action_pressed("actionButton") and global.temPergunta == true:
		print("Tem Pergunta")
	if event.is_action_pressed("hitButton") and isMonster:
	 	whichMonster.getHit()
		
		

func dialog(texto):
	if dialogavel and buffEnd==false:
		global.canMove = false
		panel.show()
		tie.reset()
		tie.buff_text(texto, 0.05)
		tie.set_state(tie.STATE_OUTPUT)
		global.set_canInventory(false)
		
			
			


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
	area = null
	isPlantaQuadro = false
	
func _on_AreaPlanta_body_enter( body ):
	if body == char:
		pressArea = true
		dialogavel = true
		texto = "Uma planta."
		isPlantaQuadro = true

func _on_AreaHit_body_enter( body ):
	if body == char:	
		isMonster = true

func _on_AreaDanger_body_enter( body ):
	if body == char:
		if monster2.hit < 1 and dialogavel == false:
			Transition.fade_to("Game.tscn")

			global.set_charPos(Vector3(16.5818,-3.0438,12.8958))


#func _on_AreaHitMonster1_body_enter( body ):
#	if body == char:
#		isMonster = true
#		whichMonster = monster1

func _on_AreaHitMonster2_body_enter( body ):
	if body == char:
		isMonster = true
		whichMonster = monster2


func _on_AreaTalkMonster1_body_enter( body ):
	if body == char:
		print(isMonster)
		isMonster = true
		dialogavel = true
		pressArea = true
		texto = "..."


func _on_AreaSala1_body_enter( body ):
	if body == char:
		Transition.fade_to("Sala1.tscn")
		global.set_charPos(Vector3(34.202877, -3.906259, 19.577702))


func _on_AreaTalkMonster2_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "Olá!"
		isMonster = true

func _on_AreaQuadro_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "Por que tem isso todo lugar...?"
		isPlantaQuadro = true

func _on_AreaSala3_body_enter( body ):
	if body == char:
		if global.get_feiColarCorredor4():
			if global.get_entregouColar() == false and global.get_feiAnswerNo() == false:
				global.set_canMove(false)
				global.set_canInventory(false)
				smrt.show_text("feiCorredor4","fei_ajudar")
			else:
				Transition.fade_to("Sala3.tscn")
				global.set_charPos(Vector3(33,-0.30,22))
		else:
			Transition.fade_to("Sala3.tscn")
			global.set_charPos(Vector3(33,-0.30,22))
		


func _on_AreaSala2_body_enter( body ):
	if body == char:
		Transition.fade_to("Sala2.tscn")
		global.set_charPos(Vector3(19.3, -0.59,-30.5))


func _on_dialog_dialog_control( info ):
	#canHit = false
	global.set_canMove(false)
	global.set_canInventory(false)
	if info.chapter == "feiCorredor4":
		if info.dialog == "fei1":
			if info.answer == 0: #é só um colar
				global.set_politeness(-5)
				global.set_compassion(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiCorredor4","fei2")
			elif info.answer == 1: #quer voltar?
				global.set_politeness(5)
				global.set_compassion(5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiCorredor4","fei2")
			elif info.answer == 2: #vamos voltar
				global.set_politeness(5)
				global.set_compassion(5)
				global.set_assertividade(5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiCorredor4","fei2")
			elif info.answer == 3: #...
				global.set_entusiasmo(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiCorredor4","fei2")
		elif info.dialog == "fei2":
			if info.answer == 0: #sim
				global.set_politeness(5)
				global.set_compassion(5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiCorredor4","fei_yes")
				global.set_feiAnswerNo(false)
			elif info.answer == 1: #não
				global.set_politeness(-5)
				global.set_compassion(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiCorredor4","fei_no")
				global.set_feiAnswerNo(true)
				global.set_feiSala2Chapter(3)
			global.set_feiSala3(false)
				
				

func _on_dialog_finished():
	global.set_canMove(true)
	global.set_canInventory(true)


func _on_AreaFeiDialogo_body_enter( body ):
	if body == char:
		global.set_feiColarCorredor4(true)
		global.set_canMove(false)
		global.set_canInventory(false)
		smrt.show_text("feiCorredor4","fei1")
		feiAreaDialogo.queue_free()
		
		

#func _on_AreaVerifica_body_enter( body ): 
#	if body == char:
#		if global.get_feiColarCorredor4():
#			if global.get_entregouColar() == false:
#				if global.get_feiAnswerNo() == false:
#					global.set_canMove(false)
#					global.set_canInventory(false)
#					smrt.show_text("feiCorredor4","fei_ajudar")
#					var posicao = char.get_translation()
#					posicao.x = 11
#					char.set_translation(posicao)
#				else:
#					areaVerifica.queue_free()
#			else:
#				areaVerifica.queue_free()
