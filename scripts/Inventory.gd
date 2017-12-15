extends Control

onready var panel = get_node("Panel")
onready var menu = get_node("Panel/menu")
onready var parent = get_parent()
onready var dialog = get_node("Dialog")
onready var tie = get_node("Dialog/TIE")
onready var panoSujo = get_node("Images/PanoSujo")
onready var panoLimpo = get_node("Images/PanoLimpo")
onready var papelFrase = get_node("Images/papelFrase")

#papel do chao do quarto 1
onready var puzzle1 = preload("res://scenes/Puzzle1.tscn")

#papel do baú do corredor 1
onready var puzzle2 = preload("res://scenes/Puzzle2.tscn")

#papel que pega do armário da sala 1
onready var puzzle3 = preload("res://scenes/Puzzle3.tscn")

#papel da mesa sala 1
onready var puzzle4 = preload("res://scenes/Puzzle4.tscn")

#papel encima da caixa sala 3
onready var puzzle8 = preload("res://scenes/Puzzle8.tscn")

#papel dentro da caixa parafusada sala 3
onready var puzzle9 = preload("res://scenes/Puzzle9.tscn")

onready var image = get_node("Image")
#onready var char = get_node("../Haku")
var selected 
var puzzleAberto = false
var selecionou
var inventoryAberto
var myItem
var itemArray
var p = null
var hasInstance = false
var seconds 
var elapsed
var time_now =0
var time_start = 0

func _ready():
	set_process_input(true)
	
	inventoryAberto = false
	if inventoryAberto == false:
		menu.set_menu(false)
	
	selecionou = false
	itemArray = global.get_itemArray()
	print("Selecionou?" + str(selecionou))
	
	
func _input(event):
	if event.is_action_pressed("openInventory") and inventoryAberto == false and global.canInventory and puzzleAberto == false:
		openInventory()
	if event.is_action_pressed("cancelButton") and puzzleAberto:
		closePuzzle()
	if event.is_action_pressed("cancelButton") and inventoryAberto:
		closeInventory()

func _process(delta):
	seconds = 0
	elapsed = 0
	time_now = OS.get_unix_time()
	elapsed = time_now - time_start
	seconds = elapsed 
	#print("elapsed : ", seconds)

func openInventory():
	global.canMove = false
	menu.set_menu(true)
	inventoryAberto = true
	panel.show()
	option()
	global.set_canHit(false)
	

func closeInventory():
	menu.set_menu(false)
	inventoryAberto = false
	panel.hide()
	global.canMove = true
	dialog.hide()
	global.set_canHit(true)
	
	
func addItem(item):
	itemArray = global.get_itemArray()
	itemArray.append(item)
	menu.options += item + "\n"
	global.set_itemArray(itemArray)
#	
func updateItems():
	itemArray = global.get_itemArray()
	menu.options = ""
	for i in range(0, itemArray.size()):
		menu.options += itemArray[i] + "\n"
	global.set_itemArray(itemArray)

func selected(o):
	
	if(o == "Papel estranho"):
		image.add_child(puzzle1.instance())
		panel.hide()
		puzzleAberto = true
		menu.set_menu(false)
		global.canMove = false
		print("Papel")
		hasInstance = true
		startTimer()
		
	elif(o == "Papel desenhado"):
		image.add_child(puzzle2.instance())
		panel.hide()
		puzzleAberto = true
		menu.set_menu(false)
		global.canMove = false
		print("Papel")
		hasInstance = true
		startTimer()
	elif (o == "Papel Colorido"):
		image.add_child(puzzle3.instance())
		panel.hide()
		puzzleAberto = true
		menu.set_menu(false)
		global.canMove = false
		hasInstance = true
		startTimer()
	elif (o == "Papel rabiscado"):
		image.add_child(puzzle4.instance())
		panel.hide()
		puzzleAberto = true
		menu.set_menu(false)
		global.canMove = false
		hasInstance = true
		startTimer()
	elif (o == "Pedaço de pano sujo"):
		p = panoSujo
		p.show()
		panel.hide()
		puzzleAberto = true
		menu.set_menu(false)
		global.canMove = false
		dialog("Parece ter algo escrito aqui...\nMas tem uma sujeira estranha em cima, não consigo ver.")
		hasInstance = false
		startTimer()
	elif (o == "Pedaço de pano"):
		p = panoLimpo
		p.show()
		panel.hide()
		puzzleAberto = true
		menu.set_menu(false)
		global.canMove = false
		dialog("Mas o que é isso...?")
		hasInstance = false
		startTimer()
	elif (o == "Papel com números"):
		image.add_child(puzzle8.instance())
		panel.hide()
		puzzleAberto = true
		menu.set_menu(false)
		global.canMove = false
		hasInstance = true
		startTimer()
	elif (o == "Papel com desenhos"):
		image.add_child(puzzle9.instance())
		panel.hide()
		puzzleAberto = true
		menu.set_menu(false)
		global.canMove = false
		hasInstance = true
		startTimer()
	elif (o == "Papel com Frase"):
		p = papelFrase
		p.show()
		panel.hide()
		puzzleAberto = true
		menu.set_menu(false)
		global.canMove = false
		hasInstance = false
		startTimer()
	else:
		menu.set_menu(false)
		closeInventory()
		global.set_canMove(true)
		
	menu.set_menu(false)
	
		
func startTimer():
	set_process(true)
	time_start = OS.get_unix_time()

func option():
	menu.set_menu(true)
	panel.show()
	for menu in get_node("Panel").get_children():
		menu.connect("option_selected", self, "selected")
	selecionou = true

func closePuzzle():
	if puzzleAberto and hasInstance:
		puzzleAberto = false
		global.canMove = true
		image.get_child(0).queue_free()
		hasInstance = false
	elif p != null and hasInstance == false:
		puzzleAberto = false
		p.hide()
	set_process(false)
	global.set_puzzleTime(seconds)
func dialog(texto):
		dialog.show()
		tie.reset()
		tie.buff_text(texto, 0.005)
		tie.set_state(tie.STATE_OUTPUT)
		

func _on_TIE_buff_end():
	global.set_canInventory(true)
	
	