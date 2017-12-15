extends Control

onready var tie = get_node("Panel/TIE")
onready var panel = get_node("Panel")
onready var inventory = get_node("../../Inventory")
onready var msg = get_node("../../Message")
var resolvido
var puzzleAberto = false
var buffEnd = false
var array1 = []

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
	resolvido = global.puzzleArmarioSala3

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
		time_start = OS.get_unix_time()
		set_process(true)
		global.set_canHit(false)
	else: return
	
func closePuzzle():
	self.hide()
	puzzleAberto = false
	tie.reset()
	global.set_canMove(true)
	set_process(false)
	global.set_puzzleTime(elapsed)
	global.set_canHit(true)
	
func _on_TIE_buff_end():
	buffEnd = true

func dialog():
	buffEnd = false
	tie.reset()
	tie.buff_text("Preciso de uma senha para abrir esse armário. (Confirmar: Enter, Cancelar X)\n", 0.005)
	tie.buff_input()
	tie.set_state(tie.STATE_OUTPUT)

func _on_TIE_input_enter( input ):
	tie.reset()
	if input == "58":
		resolvido = true
		global.set_puzzleArmario1Sala3Res(resolvido)
		tie.buff_text("O armário se abriu! Você encontrou um pano.", 0.005)
		array1 = global.get_itemArray()
		for i in range(0, array1.size()):
			if array1[i] == "Papel com números":
				array1.remove(i)
				inventory.updateItems()
				break
			
		inventory.addItem("Pano")
		buffEnd = true
	else:
		tie.buff_text(".....", 0.005)
		buffEnd = true
	 tie.set_state(tie.STATE_OUTPUT)
