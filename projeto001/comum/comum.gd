extends Node


var mapa=null
var player=null
var lista_posicao=[]

var eu={
	"atalhos":{
		"q":{},
		"w":{"id":"s_spear-001","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5}},
		"e":{},
		"r":{},
		"t":{}
	},
	"cash":0,
	"bag":{
		"tamanho":10,
		"itens":[
			{"id":"m_hp-mob-001","qtd":10},
			{"id":"m_agua-001","qtd":20},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
		]
	},
	"armas":[ # aqui teremos todas as armas dropadas no jogo
			{"id":"s_spear-001","type":"spear"},
			{"id":"s_crossbow-001","type":"crossbow"},
			{"id":"s_bow-001","type":"bow"},
			{"id":"s_staff-001","type":"staff"},
	],
	"repositorio_skill":[ # aqui teremos todas as skill upadas sua. O idela seria você ter uma delas 
		{"id":"s_spear-001","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5},"type":"spear"},
		{"id":"s_spear-002","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5},"distancia":0.5,"type":"spear"},
	],
	"mover":true,
	"pode_atirar":true,
}
var itens=[
	{"id":"m_hp-001","descricao":"hp de recuperação - porção pequena. 20% do total do HP maximo","titulo":"HP"},
	{"id":"m_mana-001","descricao":"mp de magia - porção pequena. 20% do total do MP maximo","titulo":"MP"},
	{"id":"m_hp-mob-001","descricao":"fuído sanguíneo de aracnídeos","titulo":"Itens de mob"},
	{"id":"m_mp-mob-001","descricao":"fuído espiritual de aracnídeos","titulo":"Itens de mob"},
	{"id":"m_agua-001","descricao":"Água","titulo":"Água"},
]
var receitas=[
	{"id":"m_hp-001","qtd":10,"itens":[{"id":"m_hp-mob-001","qtd":5},{"id":"m_agua-001","qtd":1}],"ciclos":5},
	{"id":"m_mana-001","qtd":10,"itens":[{"id":"m_mp-mob-001","qtd":5},{"id":"m_agua-001","qtd":1}],"ciclos":5},
]

var npc_marquisa_construir={
	"qtd":3,
	"itens":[
		{},
		{},
		{},
	]
}

var npcs={
	"mapa_cidade":[
		
	]
}

func _ready() -> void: # esta rotina é executada uma única vez, por ser global
	setCursores("cursor_attack",Input.CURSOR_ARROW)  # alterar o cursor de arrow
	setCursores("cursor_green_setting_green",Input.CURSOR_POINTING_HAND)


func getReceitaById(id):
	for i in receitas:
		if i.id == id:
			return i
	return null

func getItemById(id):
	for i in itens:
		if i.id == id:
			return i
	return null

func getImageById(id:String,padrao:bool=true):
	if id.left(2)=="m_": # se o ID iniciar com m_, indica que é material
		if FileAccess.file_exists("res://assets/material/%s.png" % [id]):# a imagem existe?
			return load("res://assets/material/%s.png" % [id])# retorna a imagem da material
		else:
			if padrao:
				return load("res://assets/skill/question.png") # imagem padrão
			else:
				return null
	if id.left(2)=="s_": # se o ID iniciar com s_, indica que é skill
		if FileAccess.file_exists("res://assets/skill/%s.png" % [id]): # a imagem existe?
			return load("res://assets/skill/%s.png" % [id]) # retorna a imagem da skill
		else:
			if padrao:
				return load("res://assets/skill/question.png") # imagem padrão
			else:
				return null
	# por default, teremos pesquisando na pasta img
	if FileAccess.file_exists("res://assets/img/%s.png" % [id]):
		return load("res://assets/img/%s.png" % [id])
	else:
		if padrao:
			return load("res://assets/skill/question.png") # imagem padrão
		else:
			return null
		
func cubic_bezier(p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, t: float):# ref: https://docs.godotengine.org/en/latest/tutorials/math/beziers_and_curves.html para entender melhor
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)
	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)
	var s = r0.lerp(r1, t)
	return s # a única coisa que fiz foi alterar Vector2 para Vector3

func getArma(qual:String): # pegamos o path passando o atalho desejado
	if eu.atalhos.get(qual.to_lower())  == {}: # verifica se a tecla passada existe algo associado
		return null # não existe, entao returna null
	var escolhido = eu.atalhos.get(qual.to_lower()).id # pega o ID da tecla
	for i in eu.armas: # iteração em armas para achar qual ID estamos falando
		if i.id == escolhido: # se o ID é o peescolhido
			if FileAccess.file_exists("res://scenes/armas/%s.tscn" % [i.type]): # verifica se o arquivo de ataque existe
				return "res://scenes/armas/%s.tscn" % [i.type] # se sim, retona o path completo do arquivo
			return null # senao retorna null
	return null # não achei o atalho correto, por segurança retornamos nulo

func getDiferencaEntreDuasDatas(data1:Dictionary,data2:Dictionary):
	var t1 = Time.get_unix_time_from_datetime_dict ( data1 ) # converto a data em unix
	var t2 = Time.get_unix_time_from_datetime_dict ( data2 )# converto a data em unix
	if (t2<=t1): # se condição aceita, indica que já acabou o tempo de espera
		var resultado={ "day": 0, "hour": 0, "minute": 0, "second": 0 } # formata o retono
		return resultado # retorna a data em Dicntionary
	var tdata=Time.get_datetime_string_from_unix_time( t2 - t1 ) # converte a data em unix da diferenca de uma com a outra
	tdata = tdata.replace("-",":").replace("T",":") # aqui formatando para ficar mais fácil,trpco -,T por :
	tdata=tdata.split(":") # converto a String em array, onde existir :
	var resultado={"day":int(tdata[2]),"hour":int(tdata[3]),"minute":int(tdata[4]),"second":int(tdata[5])} # converto para unix data, mas os valores serão dados em inteiros e não string
	resultado["day"]=int(resultado["day"]) - 1 # alinhamento porque considera hoje como um dia e não zero dias
	return resultado # retorna a data em Dicntionary

func addBag(item):
	for i in eu.bag.itens:
		if i.id == item.id:
			i.qtd += item.qtd
			return true
	for i in eu.bag.itens:
		if i.id == "":
			i.id=item.id
			i.qtd=item.qtd
			return true
	return false

func DelBag(item):
	for i in eu.bag.itens:
		if i.id == item.id:
			i.qtd -= item.qtd
			if i.qtd == 0:
				i.id=""
			return true
	return false

func verificaItemQTDBag(item)->bool: # verifica se existe este item na bag e na qtd desejada. Retorna true/false
	for i in eu.bag.itens: # iteracao nos itens da bag
		if i.id == item.id: # testa ID com o desejsado
			if i.qtd >= item.qtd: # testa se temos mais itens do que o desejado
				return true # se ok, retorna true
	return false # não achou ou não tem a quantidade desejada, retorna false
	
func pegarItemById(id):
	for i in itens:
		if i.id == id:
			return i
	return null

func setCursores(id:String,shape:Input.CursorShape,hotspot:Vector2=Vector2.ZERO): # basta passar o nome correto do arquivo na pasta sem o png e onde deseja substituir
	var image = Resource.new()
	if FileAccess.file_exists("res://assets/cursores/24x24px/%s.png" % [id]):
		image = load("res://assets/cursores/24x24px/%s.png" % [id])
	else:
		return
	Input.set_custom_mouse_cursor(image,shape,hotspot)
