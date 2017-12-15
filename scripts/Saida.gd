extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("Panel/TIE")
onready var panel = get_node ("Panel")
onready var inventory = get_node("Inventory")
onready var menu = get_node("Inventory/Panel/menu")
onready var smrt = get_node("Canvas/dialog")

onready var hanaga = get_node("Hanaga")
onready var hanagaExp = get_node("Hanaga/Expression")

onready var fei = get_node("Fei")
onready var feiExp = get_node("Fei/Expression")

onready var arina = get_node("arina")
onready var arinaExp = get_node("arina/Expression")

var p = null


var texto = null
var pressArea = false
var dialogavel = false
var buffEnd = false
var item = null
var area = null 
var puzzleNode 
var temPuzzle = false
var inventarioAberto = false
var temChave = false
var array1 = []
var portaTrancada = true
var weapon = null
var canInteract = false


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
	#global.set_hanagaSaida(true)
	#global.set_arinaSaida(true)
	#global.set_feiSaida(true)
	
	if global.get_hanagaSaida():
		hanaga.show()
	else:
		hanaga.queue_free()
	
	if global.get_feiSaida():
		fei.show()
	else:
		fei.queue_free()
	
	if global.get_arinaSaida():
		arina.show()
	else:
		arina.queue_free()

	
func _input(event):
	
	#if event.is_action_pressed("actionButton") and quarto == null and pressArea and dialogavel and inventory.inventoryAberto== false:
	#	if texto != null:
	#		dialog(texto)
	#		global.set_canMove(false)
	#		dialogavel = false
	if event.is_action_pressed("actionButton") and !dialogavel and buffEnd:
		_on_TIE_buff_end()

	#if event.is_action_pressed("actionButton") and temPuzzle and pressArea:
	#	p.openPuzzle()
	#if event.is_action_pressed("actionButton") and pressArea and quadro != null and quadroAberto == false:
	#	get_node("Puzzles/" + quadro).show()
	#	quadroAberto = true
	#	global.canMove = false

	#if event.is_action_pressed("actionButton") and quarto != null and pressArea and dialogavel:
		#verifChave(quarto)
	#	if texto != null:
	#		dialog(texto)
	#		pressArea = false
	#		dialogavel = false
	#if event.is_action_pressed("actionButton") and global.temPergunta == true:
	#	print("Tem Pergunta")
	if event.is_action_pressed("actionButton") and canInteract:
		#global.set_canMove(false)
		#global.set_canInventory(false)
		#### FEI #######################################
		if area == "fei":
			if global.get_feiSaidaChapter() == 1:
				smrt.show_text("feiSaida","fei1")
				
			elif global.get_feiSaidaChapter() == 2:
				smrt.show_text("feiSaida","fei2")

			########### HANAGA #############
		elif area == "hanaga":
			if global.get_hanagaSaidaChapter() == 1:
				smrt.show_text("hanagaSaida","hanaga1")
				
			elif global.get_hanagaSaidaChapter() == 2:
				smrt.show_text("hanagaSaida","hanaga2")

				#######  ARINA ##########
		elif area == "arina":
			if global.get_arinaSaidaChapter() == 1:
				smrt.show_text("arinaSaida","arina1")

			elif global.get_arinaSaidaChapter() == 2:
				smrt.show_text("arinaSaida","arina2")
		elif area == "botao":
			smrt.show_text("botao","text1")
			
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
	p = null
	texto = null
	global.set_temPergunta(false)


func _on_AreaQuadro_body_enter( body ):
	if body == char:
		dialogavel = true
		pressArea = true
		texto = "Por que tem isso todo lugar...?"



func _on_dialog_dialog_control( info ):
	global.set_canHit(false)
	#canHit = false
	global.set_canMove(false)
	global.set_canInventory(false)
	if info.chapter == "feiSaida":
		if info.dialog == "fei1":
			if info.answer == 0: #sim ainda bem
				global.set_politeness(5)
				global.set_compassion(5)
				global.set_entusiasmo(5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiSaida","fei2")
			elif info.answer == 1: #Assim espero e se não for? ;u;
				global.set_politeness(5)
				global.set_retratacao(5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiSaida","fei2")
			elif info.answer == 2: #é...
				global.set_entusiasmo(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("feiSaida","fei2")
			global.set_feiSaidaChapter(2)

	if info.chapter == "arinaSaida":
		if info.dialog == "arina1":
			if info.answer == 0: #parece ser a saida
				global.set_politeness(5)
				global.set_compassion(5)
				global.set_entusiasmo(5)
				global.set_volatilidade(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("arinaSaida","arina2")
			elif info.answer == 1: #espero, assim não preciso mais escutar você reclamar
				global.set_politeness(-5)
				global.set_volatilidade(5)
				global.set_compassion(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("arinaSaida","arina2")
			elif info.answer == 2: #...
				global.set_entusiasmo(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("arinaSaida","arina2")
			global.set_arinaSaidaChapter(2)
	if info.chapter == "hanagaSaida":
		if info.dialog == "hanaga1":
			if info.answer == 0: #você ficou apertando botao ate agora
				global.set_politeness(-5)
				global.set_volatilidade(5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("hanagaSaida","hanaga2")
			elif info.answer == 1: #ta bom
				global.set_politeness(5)
				global.set_volatilidade(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("hanagaSaida","hanaga2")
			elif info.answer == 2: #...
				global.set_entusiasmo(-5)
				smrt.stop()
				yield(get_tree(),"idle_frame")
				smrt.show_text("hanagaSaida","hanaga2")
			global.set_hanagaSaidaChapter(2)
	if info.chapter == "botao":
		if info.dialog =="text1":
			if info.answer == 0:
				Transition.fade_to("Final.tscn")
			elif info.answer == 1:
				return

func _on_dialog_finished():
	global.set_canMove(true)
	global.set_canInventory(true)
	global.set_canHit(true)

func _on_AreaPorta_body_enter( body ):
	if body == char:
		Transition.fade_to("Sala3.tscn")
		global.set_charPos(Vector3(33, -0.3, -22))
		
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


func _on_AreaBotao_body_enter( body ):
	if body == char:
		pressArea = true
		area = "botao"
		canInteract = true
