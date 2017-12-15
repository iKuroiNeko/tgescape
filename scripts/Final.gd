extends Node2D

onready var label = get_node("Label")
onready var texto = get_node("Label1")
onready var time = get_node("Time")
func _ready():
	set_process(true)
	global.calcTexto()
	texto.set_text(str(global.get_texto()))
	get_node("AnimationPlayer").play("up")

func _process(delta):
	time.set_text(str(global.get_puzzleTime()))
	label.set_text("Openness: " + str(global.get_openness()) + "\n Educação: " + str(global.get_politeness()) + "\nRetratação" + str(global.get_retratacao()) + "\nEntusiasmo" + str(global.get_entusiasmo()) + "\nVolatilidade: " + str(global.get_volatilidade()) + "\nCompaixao: " + str(global.get_compassion()) + "\nAssertividade" + str(global.get_assertividade()) + "\nOrganização: " + str(global.get_organizacao()) + "\nDedicação: " + str(global.get_dedicacao()) + "\nIntelecto: " + str(global.get_intelecto()) + "\n\nInterações:" + str(global.get_qtdInteracoes()) + "\nHanaga Chapter: " + str(global.get_hanagaChapter()) + "\nFei Chapter: " + str(global.get_feiChapter()) + "\nArina Chapter: " + str(global.get_arinaChapter()) + "\nTotal time: " + str(global.get_totalTime()))
