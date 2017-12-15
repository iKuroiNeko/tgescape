extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("DialogPanel/TIE")
onready var panel = get_node ("DialogPanel")
onready var msg = get_node("Message/Label")
onready var puzzlePaper = get_node("FirstRoom/papelPuzzle1")
#onready var inventory = get_node("Inventory")
onready var puzzles = get_node("Puzzles")
#onready var menu = get_node("Inventory/Panel/menu")
onready var armarioPuzzle = get_node("Puzzles/ArmarioPuzzle")
onready var boneAtt = get_node("Haku/Armature/Skeleton/BoneAttachment" )
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
var itemPicked
var isPlantaQuadro
var canInteract

var dict = {
textQuadro = "Que criatura é essa?",
textCama = "Uma cama, eu acordei nela.",
textMesa = "Tem documentos... sobre mim? \nQue lugar é esse?",
textPorta = "A porta está trancada, não consigo sair..."
}

func _ready():
	#rain.playGlobalSound()
	set_process_input(true)
	
	array1 = global.get_itemArray()
	Inventory.updateItems()
	portaTrancada = global.get_quarto1Trancado()
	itemPicked = global.get_itemPicked()
	print("Item picked" + str(global.get_itemPicked()))
	weapon = global.get_weapon()
	if itemPicked:
		puzzlePaper.hide()
		temItem = false
		get_node("Areas/AreaPuzzle1").queue_free()
		
	#posição inicial do player
	char.set_translation(global.get_charPos())
	print("Weapon:" + str(weapon))
	if weapon != null:
		get_node("Haku/Armature/Skeleton/BoneAttachment/" + weapon).show()
		global.set_canHit(true)
	else:
		print("balala")
		global.set_canHit(false)
	

		
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
		global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and pressArea and temChave == false and area =="areaPorta":
		if texto != null:
			dialog(texto)
			dialogavel = false
	if event.is_action_pressed("actionButton") and canInteract and area != null:
		if area == "mesa":
			if global.get_mesaQuarto1() == 1:
				smrt.show_text("quarto1","mesa")
			else: 
				smrt.show_text("quarto1","mesa2")
			
		global.set_canMove(false)
		canInteract = false
		global.set_canInventory(false)
			

func _on_AreaQuadro_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = dict.textQuadro
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

func _on_AreaCama_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = dict.textCama
		

func _on_TIE_buff_end():
	dialogavel = false
	buffEnd = true
		
	if Input.is_action_pressed("actionButton") and dialogavel == false and buffEnd:
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
	texto = null
	isPlantaQuadro = false
	canInteract = false
	area = null

func _on_AreaMesa_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		canInteract = true
		area = "mesa"

func _on_AreaPuzzle1_body_enter( body ):
	if body == char:
		temItem = true
		item = "Papel estranho"
		area = "Areas/AreaPuzzle1"
		puzzleNode = get_node("FirstRoom/papelPuzzle1")

func pickItem(item):
	puzzlePaper.hide()
	temItem = false
	msg.show()
	msg.set_text("Você pegou o item: " + item)
	get_node("Message/Timer").start()
	Inventory.addItem(item)
	itemPicked = true
	global.set_itemPicked(itemPicked)
	get_node(area).queue_free()
	
	
	
func _on_AreaItem_body_exit( body ):
	temItem = false
	item = null
	area = null

func _on_Timer_timeout():
	msg.hide()


func _on_AreaPorta_body_enter( body ):
	if body == char:
		array1 = global.get_itemArray()
		dialogavel = true
		pressArea = true
		area = "AreaPorta"
		verifChave()
		
func verifChave():
	array1 = global.get_itemArray()
	if global.get_quarto1Trancado():
		for i in range(0, array1.size()):
			if array1[i] == "Chave do quarto":
				#print(str(array1[i]) + str(i))
				Transition.fade_to("Corredor1.tscn")
				global.set_charPos(Vector3(2.30227,-1.81414,-47.548801))
				temChave = true
				portaTrancada == false
				global.set_quarto1Trancado(false)
				array1.remove(i)
				break
				
		if temChave == false:
			texto = dict.textPorta
	elif global.get_quarto1Trancado() == false:
		Transition.fade_to("Corredor1.tscn")
		global.set_charPos(Vector3(2.30227,-1.81414,-47.548801))

		
		
func _on_AreaArmario_body_enter( body ):
	if body == char: 
		temPuzzle = true
		pressArea = true
		p = armarioPuzzle
		

func _on_dialog_dialog_control( info ):
	global.set_canMove(false)
	global.set_canInventory(false)
	if info.chapter == "quarto1":
		if info.dialog == "mesa":
			if info.answer == 0: #que baderna..
				global.set_organizacao(10)
				global.set_mesaQuarto1(2)
			elif info.answer == 1: # parece a mesa lá de casa.
				global.set_organizacao(-10)
				global.set_mesaQuarto1(2)
func _on_dialog_finished():
	global.set_canMove(true)
	global.set_canInventory(true)
