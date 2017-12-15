extends Control

onready var tie = get_node("Panel/TIE")
onready var panel = get_node("Panel")
onready var msg = get_node("../../Message")
var resolvido
var puzzleAberto = false
var buffEnd = false

var seconds = 0
var elapsed = 0
var time_now = 0
var time_start = OS.get_unix_time()
		
func _process(delta):
	seconds = 0
	elapsed = 0
	time_now = OS.get_unix_time()
	elapsed = time_now - time_start
	seconds = elapsed
	print("elapsed : ", seconds)


func _ready():
	set_process_input(true)
	resolvido = global.puzzle2Res

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
		global.set_canMove(false)
		set_process(true)
		time_start = OS.get_unix_time()
		global.set_canHit(false)
		global.set_canInventory(false)
		
	else: return
	
func closePuzzle():
	self.hide()
	puzzleAberto = false
	tie.reset()
	global.set_canMove(true)
	set_process(false)
	global.set_puzzleTime(elapsed)
	global.set_canHit(true)
	global.set_canInventory(true)

func _on_TIE_buff_end():
	buffEnd = true

func dialog():
	buffEnd = false
	tie.reset()
	tie.buff_text("Preciso de uma senha para abrir esse baú. (Confirmar: Enter, Cancelar X)\n", 0.005)
	tie.buff_input()
	tie.set_state(tie.STATE_OUTPUT)

func _on_TIE_input_enter( input ):
	tie.reset()
	if input == "6429":
		resolvido = true
		global.set_puzzle2Res(resolvido)
		tie.buff_text("O baú se abriu! Você encontrou algumas chaves", 0.005)
		Inventory.addItem("Chave do quarto dois")
		Inventory.addItem("Chave do quarto tres")
		tie.buff_text("\nVocê também pegou um papel dentro do baú", 0.005)
		Inventory.addItem("Papel desenhado")
		global.set_hanagaChapter(3)
		global.set_areaQuadros(false)
		buffEnd = true
	else:
		tie.buff_text(".....", 0.005)
		buffEnd = true
	 tie.set_state(tie.STATE_OUTPUT)
