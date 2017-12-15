extends Control

var quadroAberto = false
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

func _input(event):
	if event.is_action_pressed("cancelButton") and quadroAberto:
		closeQuadro()
	if event.is_action_pressed("actionButton") and quadroAberto:
		closeQuadro()
		
func openPuzzle():
	self.show()
	quadroAberto = true
	global.set_canMove(false)
	time_start = OS.get_unix_time()
	set_process(true)
	global.set_canHit(false)
	
func closeQuadro():
	if quadroAberto:
		self.hide()
		global.set_canMove(true)
		quadroAberto = false
		global.set_puzzleTime(elapsed)
		set_process(false)
		global.set_canHit(true)