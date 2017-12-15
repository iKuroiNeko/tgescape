extends Control

onready var parent = get_parent()
onready var dialog = get_node("Dialog")
onready var tie = get_node("Dialog/TIE")
onready var com = get_node("Images/Com")
onready var sem = get_node("Images/Sem")
onready var inventory = get_node("../../Inventory")
onready var image = get_node("Image")
#onready var char = get_node("../Haku")
#var selected 
var buffEnd = false
var puzzleAberto = false
var p = null
var hasInstance = false
var array1 = []
var piano

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
	piano = global.get_monitorSala2()
	
	
func _input(event):
	if event.is_action_pressed("cancelButton") and puzzleAberto:
		closePuzzle()
	if event.is_action_pressed("actionButton") and puzzleAberto and buffEnd:
		closePuzzle()
		buffEnd = false

func openPuzzle():
	#if piano == false:
	self.show()
	puzzleAberto = true
	dialog()
	global.set_canMove(false)
	#else: return
	time_start = OS.get_unix_time()
	set_process(true)
	global.set_canHit(false)

func closePuzzle():
	self.hide()
	dialog.hide()
	puzzleAberto = false
	tie.reset()
	global.set_canMove(true)
	global.set_canHit(true)
	#if puzzleAberto and hasInstance:
	#	puzzleAberto = false
	#	global.canMove = true
	#	image.get_child(0).queue_free()
	#	hasInstance = false
	#elif p != null and hasInstance == false:
	#	puzzleAberto = false
	#	p.hide()
	global.set_puzzleTime(elapsed)
	set_process(false)
		

func dialog():
	tie.reset()
	dialog.show()
	if global.get_estanteItemPickedSala2():
		if global.get_monitorSala2() == false:
			p = com
			p.show()
			puzzleAberto = true
			global.set_canMove(false)
			tie.buff_text("Coloquei o cartão de memória no monitor, apareceu umas plantas...", 0.005)
			#hasInstance = false
			array1 = global.get_itemArray()
			global.set_monitorSala2(true)
			for i in range(0, array1.size()):
				if array1[i] == "Cartão de memória":
					array1.remove(i)
					break
			inventory.updateItems()
		else:
			p = com
			p.show()
			puzzleAberto = true
			global.set_canMove(false)
			tie.buff_text("...\nPlantas...", 0.005)
	elif global.get_estanteItemPickedSala2() == false:
		p = sem
		p.show()
		puzzleAberto = true
		global.set_canMove(false)
		tie.buff_text("Não aparece nada...\nParece ter um lugar para colocar um cartão de memória...", 0.005)

	tie.set_state(tie.STATE_OUTPUT)

func _on_TIE_buff_end():
	buffEnd = true
	
	
	
