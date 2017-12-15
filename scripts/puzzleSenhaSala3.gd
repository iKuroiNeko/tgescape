extends Control

onready var tie = get_node("Panel/TIE")
onready var panel = get_node("Panel")
onready var inventory = get_node("../../Inventory")
onready var msg = get_node("../../Message")
var resolvido
var puzzleAberto = false
var buffEnd = false
var array1 = []

func _ready():
	set_process_input(true)
	resolvido = global.puzzleMonitorSala3

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
		global.set_canHit(false)
		
	else: return
	
func closePuzzle():
	self.hide()
	puzzleAberto = false
	tie.reset()
	global.set_canMove(true)
	global.set_canHit(true)
	

func _on_TIE_buff_end():
	buffEnd = true

func dialog():
	buffEnd = false
	tie.reset()
	tie.buff_text("Preciso de uma senha. (Confirmar: Enter, Cancelar X)\n", 0.005)
	tie.buff_input()
	tie.set_state(tie.STATE_OUTPUT)

func _on_TIE_input_enter( input ):
	tie.reset()
	if input.to_upper() == "ROSA":
		resolvido = true
		global.set_puzzleMonitorSala3(resolvido)
		tie.buff_text("Ah, a porta abriu!", 0.005)
		global.set_saidaTrancado(false)
		array1 = global.get_itemArray()
		for i in range(0, array1.size()):
			if array1[i] == "Papel com desenhos":
				array1.remove(i)
			break
		inventory.updateItems()
		
		
		buffEnd = true
	else:
		tie.buff_text(".....", 0.005)
		buffEnd = true
	 tie.set_state(tie.STATE_OUTPUT)
