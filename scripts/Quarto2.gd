extends Spatial

onready var char = get_node("Haku")
onready var panel = get_node("DialogPanel")
onready var tie = get_node("DialogPanel/TIE")
onready var smrt = get_node("Canvas/dialog")
onready var hanaga = get_node("Hanaga")
onready var hanagaExp = get_node("Hanaga/Expression")
var dialogavel = false
var texto = null
var pressArea = false
var buffEnd = false
var array1 = []
var inventarioAberto = false
var weapon 
var isPlantaQuadro

var canInteract = false
var area = null
func _ready():
	array1 = global.get_itemArray()
	Inventory.updateItems()
	set_process_input(true)
	weapon = global.get_weapon()
	#posição inicial do player
#	char.set_translation(global.get_charPos())
	if weapon != null:
		get_node("Haku/Armature/Skeleton/BoneAttachment/" + weapon).show()
		global.set_canHit(true)
	else:
		global.set_canHit(false)
		
	if global.get_hanagaQuarto2():
		hanaga.show()
		
	global.set_hanagaChapter(4)
	
func _input(event):
	if event.is_action_pressed("actionButton") and pressArea and dialogavel:
		if texto != null:
			dialog(texto)
			dialogavel = false
			if isPlantaQuadro:
				global.set_openness(5)
			global.set_qtdInteracoes()
	if event.is_action_pressed("actionButton") and !dialogavel and buffEnd:
		_on_TIE_buff_end()
	if event.is_action_pressed("actionButton") and canInteract:
		global.set_canMove(false)
		global.set_canInventory(false)
		if global.get_hanagaChapter() == 4:
			smrt.show_text("hanagaQuarto2", "text1")
			canInteract = false
			hanagaExp.expressions("angry")
		else: 
			smrt.show_text("hanagaQuarto2","text5")
			canInteract = false
		
func dialog(texto):
	if dialogavel and buffEnd==false:
		panel.show()
		tie.reset()
		tie.buff_text(texto, 0.05)
		tie.set_state(tie.STATE_OUTPUT)
		global.set_canMove(false)
		global.set_canHit(false)

func _on_TIE_buff_end():
	dialogavel = false
	buffEnd = true
		
	if Input.is_action_pressed("actionButton") and dialogavel == false and buffEnd:
		tie.reset()
		panel.hide()
		dialogavel = true
		buffEnd = false
		global.set_canMove(true)
		global.set_canHit(true)

func _on_AreaCama_body_enter( body ):
	if body == char:
		pressArea = true
		dialogavel = true
		texto = "Uma cama, Hanaga deve ter acordado nela também..."

func _on_AreaQuadro_body_enter( body ):
	if body == char:
		pressArea = true
		dialogavel = true
		texto = "Que criatura é essa?"
		isPlantaQuadro = true

func _on_Area_body_exit( body ):
	if body == char:
		pressArea = false
		dialogavel = false
		texto = null
		area = null
		canInteract = false
		isPlantaQuadro = false
		
		
func _on_AreaPorta_body_enter( body ):
	if body == char:
		Transition.fade_to("Corredor1.tscn")
		global.set_charPos(Vector3(2.30227,-2.087398,-11.832344))


func _on_AreaArmario_body_enter( body ):
	if body == char:
		pressArea = true
		dialogavel = true
		texto = "Está vazio."


func _on_AreaHanaga_body_enter( body ):
	if body == char:
		canInteract = true
		area = "hanaga"

func _on_dialog_finished():
	global.set_canMove(true)
	global.set_canInventory(true)
	

func _on_dialog_dialog_control( info ):
	global.set_canMove(false)
	global.set_canInventory(false)
	#print(info.answer)
	global.set_canHit(false)
	if info.dialog == "text1":
		
		if info.answer == 0:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("hanagaQuarto2", "text2")
			global.set_volatilidade(-5)
			global.set_entusiasmo(-5)
			global.set_politeness(5)
			
		elif info.answer == 1:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("hanagaQuarto2", "text2")
			global.set_volatilidade(10)
		elif info.answer == 2: 
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("hanagaQuarto2", "text2")
			global.set_politeness(-5)
			global.set_assertividade(10)
			
		
		
	elif info.dialog == "text2":
		if info.answer == 0:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("hanagaQuarto2", "text3")
			global.set_politeness(5)
			global.set_volatilidade(-5)
		elif info.answer == 1:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("hanagaQuarto2", "text3")
			global.set_politeness(-5)
			global.set_volatilidade(5)
			
	elif info.dialog == "text3":
		if info.answer == 0:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("hanagaQuarto2", "text4")
			global.set_politeness(5)
			global.set_volatilidade(-5)
			global.set_hanagaChapter(5)
			global.set_hanagaQuarto2(false)
			global.set_hanagaCorredor1(true)
		elif info.answer == 1:
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("hanagaQuarto2", "text4")
			global.set_volatilidade(5)
			global.set_hanagaChapter(5)
			global.set_hanagaQuarto2(false)
			global.set_hanagaCorredor1(true)
		elif info.answer == 2: 
			smrt.stop()
			yield(get_tree(),"idle_frame")
			smrt.show_text("hanagaQuarto2", "text4")
			global.set_politeness(-5)
			global.set_volatilidade(5)
			global.set_hanagaChapter(5)
			global.set_hanagaQuarto2(false)
			global.set_hanagaCorredor1(true)
			
			