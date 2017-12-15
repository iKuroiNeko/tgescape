extends Node

const qtdObjetos = 62
const qtdMonster = 2
var qtdInteracoes = 0
var qtdIntMonster = 0

var dict = {
				#Agreeableness
				politenessLow = "Gosta de buscar conflito, parece que não se importa muito em se mostrar educado com os outros... ",
				politenessHigh = "Quanta educação, respeito... gosto disso. ",
				politenessMedium = "Se mantém educado as vezes, mas sabe ser estúpido com quem julga não merecer. ",
				compassionLow = "Não parece se importar muito com os sentimentos dos outros... ",
				compassionHigh = "Gosta de ajudar os outros e se importa com seus sentimentos. ",
				compassionMedium = "Humm... Se preocupa com outras pessoas mas também busca ter mais tempo para si mesmo. ",
				#Conscientiousness
				dedicacaoLow = "Deveras distraído... sempre adiando suas decisões. ",
				dedicacaoHigh = "Focado, mantém seus planos e decisões. ",
				dedicacaoMedium = "Mantém o foco em coisas de seu interesse, mas nada o impede de procrastinar as vezes... ",
				orderlinessLow = "Não se incomoda com desorganização, aparentemente não se sente confortável com rotinas. ",
				orderlinessHigh = "Gosta das coisas organizadas, tem preferência por seguir rotinas. ",
				orderlinessMedium = "Nem sempre segue rotinas, seu modo de organização é balanceado. ",
				#Extraversion
				enthusiasmLow = "Não é muito caloroso... prefere não se abrir com os outros. ",
				enthusiasmHigh = "Animado, se abre facilmente para as pessoas e demonstra seus sentimentos quando está feliz. ",
				enthusiasmMedium = "Aparenta ser reservado com desconhecidos, mas pode se abrir com facilidade se possuir confiança. ",
				assertiveLow = "Não demonstra muito suas opiniões, prefere que outros tomem a liderança. ",
				assertiveHigh = "Possui uma personalidade forte, busca ser o primeiro a agir e tomar a liderança. ",
				assertiveMedium = "Se a ocasião for favorável, irá buscar tomar a liderança. ",
			
				#Openness
				opennessLow = "Parece não se importar muito com pinturas... nem poesia. Que pena. ",
				opennessHigh = "Parece gostar da natureza e acredita na importância da arte. Interessante! ",
				opennessMedium = "Pode até apreciar arte e natureza, mas aparentemente estes não são seu foco.",
				intellectLow = "Não gosta de materiais complicados... deve evitar esse tipo de assunto. ",
				intellectHigh = "Gosta de conteúdos mais complexos... talvez tenha se divertido com os enigmas que espalhei pela casa. ",
				
				
				#Neuroticism
				volatilidadeLow = "É bem tranquilo, mantendo suas emoções sob controle sem perder a compostura. Interessante...",
				volatilidadeHigh = "Parece se irritar com facilidade... Esquentado.",
				volatilidadeMedium = "Acredito que determinadas situações possam irritar profundamente este humano... Mas talvez em outras ele busque manter a compostura apesar da pressão.",
				retratacaoLow = "Raramente se sente deprimido e envergonhado, parecer ser bem confiante.",
				retratacaoHigh = "Aparenta possuir muitas dúvidas sobre as coisas... além de se sentir facilmente ameaçado."
				}
############## BIG FIVE VARIABLES ####################
var politeness = 50
var compassion = 50

var entusiasmo = 50
var assertividade = 50

var volatilidade = 50
var retratacao = 50

var intelecto = 50
var openness = 50

var dedicacao = 50
var organizacao = 50
######################################################

# AGREEABLENESS
func get_politeness():
	return politeness

func set_politeness(p):
	politeness += p

func get_compassion():
	return compassion

func set_compassion(c):
	compassion += c

# NEUROTICISM
func get_retratacao():
	return retratacao

func set_retratacao(r):
	retratacao += r

func get_volatilidade():
	return volatilidade

func set_volatilidade(v):
	volatilidade += v

 # OPENNESS
func get_openness():
	return openness

func set_openness(o):
	openness += o

func get_intelecto():
	return intelecto

func set_intelecto(i):
	intelecto += i


# EXTRAVERSION
func get_entusiasmo():
	return entusiasmo

func set_entusiasmo(e):
	entusiasmo += e

func set_assertividade(as):
	assertividade += as

func get_assertividade():
	return assertividade

# CONSCIECIOUSNESS
func get_organizacao():
	return organizacao

func set_organizacao(org):
	organizacao += org

func get_dedicacao():
	return dedicacao

func set_dedicacao(ded):
	dedicacao += ded

func set_qtdInteracoes():
	qtdInteracoes += 1

func get_qtdInteracoes():
	return qtdInteracoes

func calc_interacoes():
	if qtdInteracoes < qtdObjetos:
		set_openness(-10)
	
	elif qtdInteracoes > qtdObjetos:
		set_openness(10)
	pass

##### DEFINIÇÃO DO TEXTO DO PERFIL PSICOLÓGICO ########
var ent #
var pol #
var inte
var retr# 
var op#
var ded
var cp
var org
var ast
var vol
var texto

func calcTexto():
	#cálculo Entusiasmo
	if get_entusiasmo() <= 30:
		ent = dict.enthusiasmLow
	elif get_entusiasmo()  >= 31 and get_entusiasmo() <= 70:
		ent = dict.enthusiasmMedium
	else:
		ent = dict.enthusiasmHigh
	
	#cálculo Educação
	if get_politeness() <= 30:
		pol = dict.politenessLow
	elif get_politeness() >= 31 and get_entusiasmo() < 70:
		pol = dict.politenessMedium
	else:
		pol = dict.politenessHigh
	
	#calculo intelecto
	if get_intelecto() <= 50:
		inte = dict.intellectLow
	else:
		inte = dict.intellectHigh
		
	#calculo retratacao
	if get_retratacao() <= 50:
		retr = dict.retratacaoLow
	else:
		retr = dict.retratacaoHigh
		
#calculo abertura para experiencia:
	if get_openness() <=30:
		op = dict.opennessLow
	elif get_openness() >= 31 and get_openness() < 70:
		op = dict.opennessMedium
	else:
		op = dict.opennessHigh
		
#calculo compaixao:
	if get_compassion() <=30:
		cp = dict.compassionLow
	elif get_compassion() >= 31 and get_compassion() < 70:
		cp = dict.compassionMedium
	else:
		cp = dict.compassionHigh

	#calculo volatilidade:
	if get_volatilidade() <=30:
		vol = dict.volatilidadeLow
	elif get_volatilidade() >= 31 and get_volatilidade() < 70:
		vol = dict.volatilidadeMedium
	else:
		vol = dict.volatilidadeHigh
		
	#calculo organização:
	if get_organizacao() <=30:
		org = dict.orderlinessLow
	elif get_organizacao() >= 31 and get_organizacao()< 70:
		org = dict.orderlinessMedium
	else:
		org = dict.orderlinessHigh

	#calculo dedicacao
	if get_dedicacao() <=50:
		ded = dict.dedicacaoLow
	else:
		ded = dict.dedicacaoHigh
		
		#calculo assertividade
	if get_assertividade() <=30:
		ast = dict.assertiveLow
	elif get_assertividade() >= 31 and get_assertividade() < 70:
		ast = dict.assertiveMedium
	else:
		ast = dict.assertiveHigh

	
	
	
	#texto:
	#interessante, interessante... humanos são interessantes.\n
	#<nome player>... Esse me chamou a atenção. 
	# --- Final Bom: Considerou salvar pessoas que mal conhecia!
	#Imagino se todos são assim. Talvez eu devesse realizar essa pesquisa mais vezes.
	# --- Final Ruim: Por que será que deixou gente para trás? Se ajudou um, o que o impediu
	#de ajudar os outros também? Estranho... esses humanos são curiosos
	# --- Final Muito Ruim: Esse humano... saiu sozinho. Por quê? . <não sei mais>
	# Bem, vamos analisar mais profundamente... <nome player> é um humano bem interessante mesmo.
	# <vai colocando um fator na frente do outro do dicionário>

func get_texto():
	get_final()
	texto = str(finalTxt) + str(op) + str(ent) + str(retr) + str(pol) + str(inte)
	texto = str(texto) + str(cp) + str(vol) + str(org) + str(ast) + "  Bem... Isso tudo me ajudou bastante na minha pesquisa sobre os humanos. Irei melhorar meus métodos de análise e entender completamente como os humanos se comportam!"
	return texto
	
var finalTxt

func get_final():
	if get_hanagaSaida() and get_arinaSaida() and get_feiSaida():
		finalTxt = "Este humano... vamos ver. Considerou salvar pessoas que mal conhecia! Imagino se todos são assim. Talvez eu devesse realizar essa pesquisa mais vezes. Este humano em especial... "
	elif get_hanagaSaida() == false and get_arinaSaida() or get_arinaSaida() == false and get_hanagaSaida():
		finalTxt = "Esse humano... Por que será que deixou gente para trás? Se ajudou um, o que o impediu de ajudar os outros também? Estranho... esses humanos são curiosos. Vamos analisar este humano mais profundamente."
	elif get_hanagaSaida() == false and get_arinaSaida() == false and get_feiSaida() == false:
		finalTxt = "Esse humano... saiu sozinho. Por quê? Bem, vamos analisar mais profundamente..." + get_playerName() + " é um humano bem interessante mesmo."
########################################################

var quarto1Trancado = true
var quarto2Trancado = true
var quarto3Trancado = true
var quarto4Trancado = true
var corredor2Trancado = true
var corredor3Trancado = true
var corredor4Trancado = true
var playerName



func get_playerName():
	if playerName == null:
		playerName = "Haku"
	return playerName

func set_playerName(pn):
	playerName = pn

var itemArray = []
var puzzleArmarioSala3 = false
var puzzleArmario2Sala3 = false
var pianoLimpo = false
var puzzleMonitorSala3 = false
var caixa = false
var puzzle1Res = false
var puzzle2Res = false
var puzzle3Res = false
var puzzle4Res = false
var puzzleArmarioSala1 = false
var puzzlePCS1Res = false
var puzzleArmario2Sala2 = false
var itemPicked = false
var charPos = Vector3(10.603292,-1.532661,0)
var canMove = true
var canInventory = true
var respondeu = false
var weapon = null
var otherCharWalk = false
var portaVidroFechada = true
var paperPicked = false
var paperPickedSala3 = false
var pdPicked = false
var panoSujoPicked = false
var chapterFei = "firstEncounterFei"
var saidaTrancado = true
var puzzleArmarioSala2 = false
var estanteItemPickedSala2 = false
var bauSala2 = false
var monitorSala2 = false
var cabineteSala2 = false
var fluidoResolvido = false
var panoLimpoSala2 = false
var chaveRustSala2 = true
var papelFrase = false
var puzzleLife = false
var puzzlePudim = false
var canHit

var puzzleTime = 0
var totalTime = 0
############### GETS E SETS ###########################
func set_canHit(n):
	canHit = n
func get_canHit():
	return canHit 

func get_quarto1Trancado():
	return(quarto1Trancado)

func set_quarto1Trancado(qrtTrancado):
	quarto1Trancado = qrtTrancado

func get_quarto2Trancado():
	return(quarto2Trancado)

func set_quarto2Trancado(qrtTrancado):
	quarto2Trancado = qrtTrancado

func get_quarto3Trancado():
	return(quarto3Trancado)

func set_quarto3Trancado(qrtTrancado):
	quarto3Trancado = qrtTrancado

func set_corredor2Trancado(qrtTrancado):
	corredor2Trancado = qrtTrancado

func get_corredor2Trancado():
	return corredor2Trancado

func set_portaVidroFechada(pv):
	portaVidroFechada = pv

func get_portaVidroFechada():
	return portaVidroFechada

func set_corredor3Trancado(qrtTrancado):
	corredor3Trancado = qrtTrancado

func get_corredor3Trancado():
	return corredor3Trancado

func set_corredor4Trancado(qrtTrancado):
	corredor4Trancado = qrtTrancado

func get_corredor4Trancado():
	return corredor4Trancado
	
func get_itemArray():
	return itemArray

func set_itemArray(ia):
	itemArray = ia
	
func set_itemPicked(itemPick):
	itemPicked = itemPick

func get_itemPicked():
	return itemPicked
	
func set_paperPicked(itemPick):
	paperPicked = itemPick

func get_paperPicked():
	return paperPicked
	
func set_paperPickedS3(itemPick):
	paperPickedSala3 = itemPick

func get_paperPickedS3():
	return paperPickedSala3
	
func set_pdPicked(pd):
	pdPicked = pd

func get_pdPicked():
	return pdPicked

func set_panoSujoPicked(itemPick):
	panoSujoPicked = itemPick

func get_panoSujoPicked():
	return panoSujoPicked

func get_charPos():
	return charPos
	
func set_charPos(position):
	charPos = position

func get_canMove():
	return canMove

func set_canMove(move):
	canMove = move

func get_canInventory():
	return canInventory

func set_canInventory(ci):
	canInventory = ci

func get_respondeu():
	return respondeu

func set_respondeu(resp):
	respondeu = resp

func get_weapon():
	return weapon
	
func set_weapon(wp):
	weapon = wp

func get_otherCharWalk():
	return otherCharWalk
	
func set_otherCharWalk(ocw):
	otherCharWalk = ocw


func get_chapterFei():
	return chapterFei
	
func set_chapterFei(cf):
	chapterFei = cf

func set_caixaParafuso(itemPick):
	caixa = itemPick

func get_caixaParafuso():
	return caixa
	
# piano sala 3
func set_pianoLimpo(piano):
	pianoLimpo = piano
	
func get_pianoLimpo():
	return pianoLimpo


############# PUZZLES GETS E SETS ############
#puzzle do armario no primeiro quarto
func get_puzzle1Res():
	return puzzle1Res	

func set_puzzle1Res(puzzle1):
	puzzle1Res = puzzle1 

# puzzle do baú - primeiro corredor
func get_puzzle2Res():
	return puzzle2Res

func set_puzzle2Res(puzzle2):
	puzzle2Res = puzzle2

#puzzle do armario - segundo corredor
func get_puzzle3Res():
	return puzzle3Res

func set_puzzle3Res(puzzle3):
	puzzle3Res = puzzle3

#puzzle do life - sala 1
func get_puzzle4Res():
	return puzzle4Res

func set_puzzle4Res(puzzle4):
	puzzle4Res = puzzle4
	
# puzzle armario sala 1
func set_puzzleArmarioSala1Res(as1):
	puzzleArmarioSala1 = as1
	
func get_puzzleArmarioSala1Res():
	return puzzleArmarioSala1

#puzzle pc sala 1
func set_puzzlePCS1Res(as1):
	puzzlePCS1Res = as1
	
func get_puzzlePCS1Res():
	return puzzlePCS1Res

# puzzle armario1 sala 3
func set_puzzleArmario1Sala3Res(as3):
	puzzleArmarioSala3 = as3

func get_puzzleArmario1Sala3Res():
	return puzzleArmarioSala3

# puzzle armario2 sala 3
func set_puzzleArmario2Sala3Res(a2s3):
	puzzleArmario2Sala3 = a2s3

func get_puzzleArmario2Sala3Res():
	return puzzleArmario2Sala3

# puzzle monitor sala 3
func set_puzzleMonitorSala3(monitor):
	puzzleMonitorSala3 = monitor

func get_puzzleMonitorSala3():
	return puzzleMonitorSala3

func get_puzzleTime():
	return puzzleTime

func set_puzzleTime(time):
	puzzleTime += time

func set_totalTime(time):
	totalTime += time
	
func get_totalTime():
	return totalTime
	
func updateWeapon():
	get_weapon()


var temPergunta = false

func get_temPergunta():
	return temPergunta

func set_temPergunta(perg):
	temPergunta = perg

# puzzle armario2 sala 2
func set_puzzleArmario2Sala2Res(a2s2):
	puzzleArmario2Sala2 = a2s2

func get_puzzleArmario2Sala2Res():
	return puzzleArmario2Sala2

func get_puzzleLife():
	return puzzleLife

func set_puzzleLife(pz):
	puzzleLife = pz

func get_puzzlePudim():
	return puzzlePudim

func set_puzzlePudim(pp):
	puzzlePudim = pp

func set_saidaTrancado(qrtTrancado):
	saidaTrancado = qrtTrancado

func get_saidaTrancado():
	return saidaTrancado

# puzzle armario1 sala 2
func set_puzzleArmarioSala2Res(as2):
	puzzleArmarioSala2 = as2

func get_puzzleArmarioSala2Res():
	return puzzleArmarioSala2

func set_estanteItemPickedSala2(itemPick):
	estanteItemPickedSala2 = itemPick

func get_estanteItemPickedSala2():
	return estanteItemPickedSala2

func set_bauSala2(itemPick):
	bauSala2 = itemPick

func get_bauSala2():
	return bauSala2

func set_monitorSala2(itemPick):
	monitorSala2 = itemPick

func get_monitorSala2():
	return monitorSala2
	
func set_fluidoResolvidoSala2(itemPick):
	fluidoResolvido = itemPick

func get_fluidoResolvidoSala2():
	return fluidoResolvido
	
func set_cabineteSala2(itemPick):
	cabineteSala2 = itemPick

func get_cabineteSala2():
	return cabineteSala2
	
func set_panoLimpoSala2(itemPick):
	panoLimpoSala2 = itemPick

func get_panoLimpoSala2():
	return panoLimpoSala2

func get_papelFrase():
	return papelFrase

func set_papelFrase(pf):
	papelFrase = pf
func set_chaveRustSala2(itemPick):
	chaveRustSala2 = itemPick

func get_chaveRustSala2():
	return chaveRustSala2

var areaQuadros = true
func get_areaQuadros():
	return areaQuadros

func set_areaQuadros(aq):
	areaQuadros = aq

############# CALCULO TEMPO ###################
var time_now = 0
var time_start = OS.get_unix_time()
var elapsed=0
var seconds=0
func _ready():
	set_process(true)
	

func _process(delta):
	time_now = OS.get_unix_time()
	elapsed = time_now - time_start
	seconds = elapsed


func stopTimer():
	set_process(false)
	set_totalTime(elapsed)
########## conversas e localizacoes #####################

var hanagaChapter = 1
var feiChapter = 1
var arinaChapter = 1

var feiSala2Chapter = 1
var hanagaSala2Chapter = 1
var arinaSala2Chapter = 1

var feiSala3Chapter = 1
var hanagaSala3Chapter = 1
var arinaSala3Chapter = 1

var feiSaidaChapter = 1
var hanagaSaidaChapter = 1
var arinaSaidaChapter = 1

var monsterPlantaChapter = 1
var maquinaSala1Chapter = 1
var monsterPoemaChapter = 1

var mesaQuarto1 = 1

var hanagaTrancado = true
var hanagaQuarto2 = true
var hanagaCorredor1 = false
var hanagaSala1 = false
var hanagaSala2 = false
var hanagaSala3 = false
var hanagaSaida = false

var triggerFei = true
var feiCorredor1 = true
var feiSala1 = false
var feiSala2 = false
var feiSala3 = false
var feiSaida = false

var arinaTrancada = true
var arinaQuarto3 = true
var arinaCorredor1 = false
var arinaCorredor2 = false
var arinaSala1 = false
var arinaSala2 = false
var arinaSala3 = false
var arinaSaida = false

var entregouColar = false
var colarPicked = false
var feiColarCorredor4 = false
var feiAnswerNo = false
var passCorredor4 = false
var passSaida = false
var answerHelp = false
var passAreaC1 = false
var answeredC1 = false

func get_passAreaC1():
	return passAreaC1
	
func set_passAreaC1(passC1):
	passAreaC1 = passC1

func get_answerHelp():
	return answerHelp
	
func set_answerHelp(aHelp):
	answerHelp = aHelp
	
func get_answeredC1():
	return answeredC1
	
func set_answeredC1(answered):
	answeredC1 = answered

func get_mesaQuarto1():
	return mesaQuarto1

func set_mesaQuarto1(mq):
	mesaQuarto1 = mq
	
func get_passSaida():
	return passSaida

func set_passSaida(psai):
	passSaida = psai

func get_passCorredor4():
	return passCorredor4

func set_passCorredor4(pc4):
	passCorredor4 = pc4

func get_entregouColar():
	return entregouColar

func set_entregouColar(ec):
	entregouColar = ec

func get_colarPicked():
	return colarPicked

func set_colarPicked(cpick):
	colarPicked = cpick

func get_feiColarCorredor4():
	return feiColarCorredor4

func set_feiColarCorredor4(fcolar):
	feiColarCorredor4 = fcolar

func get_feiAnswerNo():
	return feiAnswerNo

func set_feiAnswerNo(fno):
	feiAnswerNo = fno

func get_hanagaSala3Chapter():
	return hanagaSala3Chapter

func set_hanagaSala3Chapter(h3c):
	hanagaSala3Chapter = h3c

func get_feiSala3Chapter():
	return feiSala3Chapter

func set_feiSala3Chapter(f3c):
	feiSala3Chapter = f3c

func get_arinaSala3Chapter():
	return arinaSala3Chapter

func set_arinaSala3Chapter(a3c):
	arinaSala3Chapter = a3c

func get_hanagaSala2Chapter():
	return hanagaSala2Chapter

func set_hanagaSala2Chapter(h2c):
	hanagaSala2Chapter = h2c

func get_feiSala2Chapter():
	return feiSala2Chapter

func set_feiSala2Chapter(f2c):
	feiSala2Chapter = f2c

func get_arinaSala2Chapter():
	return arinaSala2Chapter

func set_arinaSala2Chapter(a2c):
	arinaSala2Chapter = a2c
func get_hanagaSaidaChapter():
	return hanagaSaidaChapter

func set_hanagaSaidaChapter(hsai):
	hanagaSaidaChapter = hsai

func get_feiSaidaChapter():
	return feiSaidaChapter

func set_feiSaidaChapter(fsai):
	feiSaidaChapter = fsai

func get_arinaSaidaChapter():
	return arinaSaidaChapter

func set_arinaSaidaChapter(asai):
	arinaSaidaChapter = asai

func get_monsterPoemaChapter():
	return monsterPoemaChapter

func set_monsterPoemaChapter(mpc3):
	monsterPoemaChapter = mpc3

func get_monsterPlantaChapter():
	return monsterPlantaChapter

func set_monsterPlantaChapter(mpc):
	monsterPlantaChapter = mpc
	
func get_maquinaSala1Chapter():
	return maquinaSala1Chapter

func set_maquinaSala1Chapter(ms1):
	maquinaSala1Chapter = ms1

func get_hanagaChapter():
	return hanagaChapter

func set_hanagaChapter(hc):
	hanagaChapter = hc

func get_feiChapter():
	return feiChapter

func set_feiChapter(fc):
	feiChapter = fc

func get_arinaChapter():
	return arinaChapter

func set_arinaChapter(ac):
	arinaChapter = ac
	
func get_hanagaQuarto2():
	return hanagaQuarto2

func set_hanagaQuarto2(q2):
	hanagaQuarto2 = q2

func get_hanagaCorredor1():
	return hanagaCorredor1

func set_hanagaCorredor1(c1):
	hanagaCorredor1 = c1
	
func get_hanagaSala1():
	return hanagaSala1

func set_hanagaSala1(s1):
	hanagaSala1 = s1

func get_hanagaSala2():
	return hanagaSala2

func set_hanagaSala2(h2):
	hanagaSala2 = h2

func get_hanagaSala3():
	return hanagaSala3

func set_hanagaSala3(s3):
	hanagaSala3 = s3

func get_hanagaSaida():
	return hanagaSaida

func set_hanagaSaida(hs):
	hanagaSaida = hs

var hanagaSalaVidro = false
func set_hanagaSalaVidro(sv):
	hanagaSalaVidro = sv

func get_hanagaSalaVidro():
	return hanagaSalaVidro

func get_hanagaTrancado():
	return hanagaTrancado

func set_hanagaTrancado(ht):
	hanagaTrancado = ht

func get_arinaCorredor1():
	return arinaCorredor1

func set_arinaCorredor1(a1):
	arinaCorredor1 = a1

func get_arinaQuarto3():
	return arinaQuarto3

func set_arinaQuarto3(s3):
	arinaQuarto3 = s3

func get_arinaCorredor2():
	return arinaCorredor2

func set_arinaCorredor2(c2):
	arinaCorredor2 = c2


var areaTriggerFei = true
func get_areaTriggerFei():
	return areaTriggerFei

func set_areaTriggerFei(atf):
	areaTriggerFei = atf

func get_arinaTrancada():
	return arinaTrancada

func set_arinaTrancada(at):
	arinaTrancada = at


func get_arinaSala1():
	return arinaSala1

func set_arinaSala1(s1):
	arinaSala1 = s1
	
func get_arinaSala2():
	return arinaSala2

func set_arinaSala2(s2):
	arinaSala2 = s2

func get_arinaSala3():
	return arinaSala3

func set_arinaSala3(s3):
	arinaSala3 = s3

func get_arinaSaida():
	return arinaSaida

func set_arinaSaida(as):
	arinaSaida = as

func get_feiCorredor1():
	return feiCorredor1

func set_feiCorredor1(feiC1):
	feiCorredor1 = feiC1

func get_feiSala1():
	return feiSala1

func set_feiSala1(f1):
	feiSala1 = f1

func get_feiSala2():
	return feiSala2

func set_feiSala2(f2):
	feiSala2 = f2

func get_feiSala3():
	return feiSala3

func set_feiSala3(f3):
	feiSala3 = f3

func get_feiSaida():
	return feiSaida

func set_feiSaida(fs):
	feiSaida = fs


	