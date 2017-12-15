extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("Panel/TIE")
onready var panel = get_node ("Panel")
onready var inventory = get_node("Inventory")
onready var menu = get_node("Inventory/Panel/menu")
onready var monster1 = get_node("Monsters/monster1")
onready var monster2 = get_node("Monsters/monster2")
onready var smrt = get_node("Canvas/dialog")
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
		
func _input(event):
	
	if event.is_action_pressed("actionButton") and quarto == null and pressArea and dialogavel and inventory.inventoryAberto== false:
		if texto != null:
			dialog(texto)
			global.set_canMove(false)
			dialogavel = false
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
	if event.is_action_pressed("actionButton") and canInteract:
		global.set_canMove(false)
		global.set_canInventory(false)
		if global.get_monsterPoemaChapter() == 1:
			smrt.show_text("MonsterPoema", "text1")
			canInteract = false
		else: 
			smrt.show_text("MonsterPoema","text4")
			canInteract = false
		

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
	
func _on_AreaPlanta_body_enter( body ):
	if body == char:
		pressArea = true
		dialogavel = true
		texto = "Uma planta."


func _on_AreaCorredor1_body_enter( body ):
	if body == char:
		Transition.fade_to("Corredor1.tscn")
		global.set_charPos(Vector3(15.908468,-1.53266,61.27647))


func _on_AreaHit_body_enter( body ):
	if body == char:	
		isMonster = true



func _on_AreaDanger_body_enter( body ):
	if body == char:
		if monster2.hit < 1 and dialogavel == false:
			Transition.fade_to("Game.tscn")
			global.set_charPos(Vector3(16.5818,-3.0438,12.8958))

	


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
		canInteract = true
		area = "monsterPoema"
		#dialogavel = true
		#pressArea = true
		#texto = "Minha energia é o desafio,\n minha motivação é o impossível\n e é por isso que preciso\nser, à força e a esmo, inabalável.\n-AugustoBranco"


func _on_AreaSala1_body_enter( body ):
	if body == char:
		Transition.fade_to("Sala1.tscn")
		global.set_charPos(Vector3(34.202877, -3.906259, 19.577702))


func _on_AreaTalkMonster2_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "Você já viu um peixe gato? Fica a reflexão."


func _on_AreaQuadro_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "De novo isso??"


func _on_AreaPorta1_body_enter( body ):
	if body == char:
		Transition.fade_to("Sala1.tscn")
		global.set_charPos(Vector3(-19.176872, -3.90626, -31.681667))


func _on_AreaPorta2_body_enter( body ):
	if body == char:
		Transition.fade_to("Sala2.tscn")
		global.set_charPos(Vector3(-30.359131,0.9,-16.132713))

func _on_dialog_finished():
	global.set_canMove(true)
	global.set_canInventory(true)


func _on_dialog_dialog_control( info ):
	global.set_canMove(false)
	global.set_canInventory(false)
	if info.dialog == "text1":
		if info.answer == 0:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("MonsterPoema", "text2")
		elif info.answer == 1:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("MonsterPoema", "text2")
			global.set_openness(10)
	elif info.dialog == "text2":
		if info.answer == 0:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("MonsterPoema", "text3")
			global.set_openness(10)
		elif info.answer == 1:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("MonsterPoema", "text3")
			global.set_openness(-10)
			global.set_compassion(-5)
		elif info.answer == 2:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("MonsterPoema", "text3")
			global.set_openness(-5)
			global.set_politeness(5)
	global.set_monsterPoemaChapter(2)
