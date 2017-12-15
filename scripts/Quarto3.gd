extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("DialogPanel/TIE")
onready var panel = get_node ("DialogPanel")
onready var expArina = get_node("arina/Expression")
onready var smrt = get_node("Canvas/dialog")
var p = null

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
var weapon = null
var canInteract
var isPlantaQuadro = false

func _ready():
	
	set_process_input(true)
	array1 = global.get_itemArray()
	Inventory.updateItems()
	#tirar
	global.set_arinaChapter(4)
	#posição inicial do player
	char.set_translation(global.get_charPos())
	weapon = global.get_weapon()
	if weapon != null:
		get_node("Haku/Armature/Skeleton/BoneAttachment/" + weapon).show()
		global.set_canHit(true)
	else:
		global.set_canHit(false)	
		
	if global.get_arinaQuarto3():
		get_node("arina").show()
	elif global.get_arinaQuarto3() == false:
		get_node("arina").queue_free()
	
func _input(event):
	
	if event.is_action_pressed("actionButton") and pressArea and dialogavel and Inventory.inventoryAberto== false:
		if texto != null:
			dialog(texto)
			dialogavel = false
			if isPlantaQuadro:
				global.set_openness(5)
			global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and !dialogavel and buffEnd:
		_on_TIE_buff_end()
	if event.is_action_pressed("actionButton") and temItem:
		if item != null:
			pickItem(item)
	if event.is_action_pressed("actionButton") and temPuzzle and pressArea:
		p.openPuzzle()
	if event.is_action_pressed("actionButton") and pressArea and temChave == false and area =="areaPorta":
		if texto != null:
			dialog(texto)
			dialogavel = false
	if event.is_action_pressed("actionButton") and canInteract:
		global.set_canMove(false)
		global.set_canInventory(false)
		if global.get_arinaChapter() == 4:
			smrt.show_text("arinaQuarto3", "text1")
			canInteract = false
			expArina.expressions("crying")
		else: 
			smrt.show_text("arinaQuarto3","text4")
			canInteract = false
		
func _on_AreaQuadro_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "Mais um daqueles quadros..."
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
		texto = "Uma cama."
		


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




func _on_AreaPorta_body_enter( body ):
	if body == char:
		global.set_charPos(Vector3(0.595465, -1.53266, 24.154091))
		Transition.fade_to("Corredor1.tscn")
		

func _on_AreaArmario_body_enter( body ):
	if body == char: 
		dialogavel = true
		texto = "O armário está vazio."
		pressArea = true
		
		
		

func _on_AreaArina_body_enter( body ):
	if body == char:
		canInteract = true
		area = "arina"


func _on_dialog_dialog_control( info ):
	global.set_canHit(false)
	global.set_canMove(false)
	global.set_canInventory(false)
	if info.dialog == "text1":
		if info.answer == 0:
			global.set_politeness(5)
			global.set_compassion(5)
			global.set_volatilidade(-5)
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("arinaQuarto3","text2")
		elif info.answer == 1:
			global.set_volatilidade(5)
			global.set_politeness(-5)
			global.set_compassion(-5)
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("arinaQuarto3","text2")
		elif info.answer == 2:
			global.set_compassion(-5)
			global.set_politeness(-5)
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("arinaQuarto3","text2")
	elif info.dialog == "text2":
		if info.answer == 0:
			global.set_politeness(5)
			global.set_entusiasmo(5)
			global.set_volatilidade(-5)
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("arinaQuarto3","text3")
			global.set_arinaChapter(5)
			global.set_arinaQuarto3(false)
			global.set_arinaCorredor1(true)
			global.set_feiChapter(4)
		elif info.answer == 1:
			global.set_politeness(-5)
			global.set_compassion(-5)
			global.set_volatilidade(5)
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("arinaQuarto3","text3")
			global.set_arinaChapter(5)
			global.set_arinaQuarto3(false)
			global.set_arinaCorredor1(true)
			global.set_feiChapter(4)
		elif info.answer == 2:
			global.set_compassion(-5)
			global.set_assertividade(5)
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("arinaQuarto3","text3")
			global.set_arinaChapter(5)
			global.set_arinaQuarto3(false)
			global.set_arinaCorredor1(true)
			global.set_feiChapter(4)
			
func _on_dialog_finished():
	global.set_canMove(true)
	global.set_canInventory(true)
	global.set_canHit(true)