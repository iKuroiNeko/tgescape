extends Spatial

onready var char = get_node("Haku")
onready var tie = get_node("DialogPanel/TIE")
onready var panel = get_node ("DialogPanel")

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
var itemPicked
var weapon = null
var isPlantaQuadro = false

func _ready():
	
	set_process_input(true)
	array1 = global.get_itemArray()
	Inventory.updateItems()	
	#posição inicial do player
	char.set_translation(global.get_charPos())
	weapon = global.get_weapon()
	if weapon != null:
		get_node("Haku/Armature/Skeleton/BoneAttachment/" + weapon).show()
		global.set_canHit(true)		
	else:
		global.set_canHit(false)
		
	
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
		global.set_charPos(Vector3(0.595465, -1.53266, 58.982391))
		Transition.fade_to("Corredor1.tscn")
		

func _on_AreaArmario_body_enter( body ):
	if body == char: 
		dialogavel = true
		texto = "O armário está vazio."
		pressArea = true
		
		
		