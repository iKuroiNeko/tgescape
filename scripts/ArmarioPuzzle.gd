extends Control

onready var tie = get_node("Panel/TIE")
onready var panel = get_node("Panel")
#onready var inventory = get_node("../../Inventory")
onready var msg = get_node("../../Message")

var resolvido
var puzzleAberto = false
var buffEnd = false
var time_now = 0
var time_start = 0
var seconds
var elapsed
var array1
func _ready():
	set_process_input(true)
	resolvido = global.puzzle1Res
	array1 = global.get_itemArray()
	
func _process(delta):
	seconds = 0
	elapsed = 0
	time_now = OS.get_unix_time()
	elapsed = time_now - time_start
	seconds = elapsed % 60
	print("elapsed : ", seconds)


func _input(event):
	if event.is_action_pressed("cancelButton") and puzzleAberto:
		closePuzzle()
		puzzleAberto = false
	if event.is_action_pressed("actionButton") and buffEnd:
		closePuzzle()
		puzzleAberto = false
	
	

func openPuzzle():
	if resolvido == false:
		self.show()
		puzzleAberto = true
		dialog()
		global.set_canInventory(false)
		global.set_canMove(false)
		time_start = OS.get_unix_time()
		set_process(true)
		global.set_canHit(false)
	else: return
	
func closePuzzle():
	self.hide()
	puzzleAberto = false
	tie.reset()
	global.set_canInventory(true)
	global.set_canMove(true)
	set_process(false)
	global.set_puzzleTime(elapsed)
	global.set_canHit(true)
func _on_TIE_buff_end():
	buffEnd = true
	pass

func dialog():
	buffEnd = false
	tie.reset()
	tie.buff_text("Consigo inserir algum código aqui... (Confirmar: Enter, Cancelar X)\n", 0.005)
	tie.buff_input()
	tie.set_state(tie.STATE_OUTPUT)

func _on_TIE_input_enter( input ):
	tie.reset()
	if input == "1794":
		resolvido = true
		global.set_puzzle1Res(resolvido)
		tie.buff_text("O armário se abriu!\nVocê encontrou uma chave.", 0.005)
		Inventory.addItem("Chave do quarto")
		buffEnd = true
		for i in range(0,array1.size()):
			if array1[i] == "Papel estranho":
				array1.remove(i)
				Inventory.updateItems()
				break
	else:
		tie.buff_text(".....", 0.005)
		buffEnd = true
	 tie.set_state(tie.STATE_OUTPUT)
