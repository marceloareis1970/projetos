extends Node

var db : SQLite = null
var db_name  = "user://repositorio.db"
var tempo_atualizaca:float=15.0 # 1 minuto
const verbosity_level : int = SQLite.NORMAL


func _ready() -> void:
	db = SQLite.new()
	db.path = db_name
	db.verbosity_level = verbosity_level
	db.open_db()
	db.query("CREATE TABLE IF NOT EXISTS tabela (campo text,valor text)")
	startDatabase()


func select(campo:String,default:String = "",multiplo:bool=false):
	if not multiplo:
		db.query("select valor from tabela where campo = '"+campo+"'")
	else:
		db.query("select campo,valor from tabela where campo like '%"+campo+"%'")
	var query_result : Array = db.query_result
	if query_result.is_empty():
		update(campo,default)
		return default
	else:
		if multiplo:
			var arrayRetorno={}
			for i in query_result:
				arrayRetorno.set(i.campo,JSON.parse_string(i.valor))
			return arrayRetorno
		return  JSON.parse_string(query_result[0].valor)
		
func update(campo:String,valor:String):
	db.query("select valor from tabela where campo = '"+campo+"'")
	var query_result : Array = db.query_result
	if query_result.is_empty():
		db.query("insert into tabela (campo,valor) values ('"+campo+"','"+valor+"')")
	else:
		db.query("update tabela set valor='%s' WHERE campo='%s'" % [valor,campo])

func startDatabase():
	var dados=[
		{
			"id":"skill_drop_001",
			"debuff":{"id":"congela_mob","damage":50,"tempo":3}, # se é um ataque que, ao toque, emite um debuff, estes serão os dados do debug
			"nome":"Ataque da meia-noite",# nome do ataque para o usuário
			"tipo":"magia",# tipo de ataque, info para o usupario
			"arquivo":"bola_de_gelo", # nome do arquivo na pasta scene/tiro
			"damage":50, # damage dela inserido 
			"speed":20, # velocidade de movimento da skill
			"elapsedtime":1.5, # tempo que a skill fica em execução, quando ativada
			"tempo":{"atual":0,"maximo":5}, # aumenta a qtd de recuperacao por segundo
			"mana":5, # mana gasta ao executar este ataque
			"descricao":"[font_size=10]%s\nUma bola de gelo atinge os inimigos, por 3s. Interalo de 5s[/font_size]",
			"melhorias":[
				{"grupo":"mana","qtd":2},# aumenta a qtd de recuperacao de mana por segundo
				{"grupo":"hp_maximo","qtd":10},# aumenta a qtd de hp_maximo
				{"grupo":"cura","qtd":2},# aumenta a qtd de cura por segundo
				{"grupo":"defesa","qtd":2},# aumenta a qtd de defesa por segundo
				{"grupo":"velocidade_ataque","qtd":2},# aumenta a qtd de velocidade de ataque por segundo
			]
		},
		{
			"id":"skill_drop_002",
			"debuff":{"id":"queima_mob","damage":50,"tempo":1},
			"tipo":"magia", 
			"nome":"Ataque do meia-dia", 
			"arquivo":"bola_de_fogo", 
			"damage":50,  
			"speed":20, 
			"elapsedtime":1.5,
			"mana":5, 
			"tempo":{"atual":0,"maximo":5}, 
			"descricao":"[font_size=10]%s\nUma bola de fogo atinge os inimigos, por 3s. Interalo de 5s[/font_size]",
			"melhorias":[ 
				{"grupo":"mana","qtd":2}, 
				{"grupo":"cura","qtd":2}, 
				{"grupo":"defesa","qtd":2}, 
				{"grupo":"velocidade_ataque","qtd":2}, 
			]
		},
		{
			"id":"skill_drop_003",
			"debuff":{},
			"tipo":"magia",
			"nome":"Poder aquático",
			"arquivo":"canhao_dagua",
			"damage":50,
			"speed":20,
			"elapsedtime":1.5, 
			"tempo":{"atual":0,"maximo":5}, 
			"mana":5,
			"descricao":"[font_size=10]%s\nLancas dáguas saem em direção aos inimigos, por 3s. Interalo de 5s[/font_size]",
			"melhorias":[
				{"grupo":"mana","qtd":2},
				{"grupo":"cura","qtd":2},
				{"grupo":"defesa","qtd":2},
				{"grupo":"velocidade_ataque","qtd":2},
			]
		},
		{
			"id":"skill_drop_004",
			"debuff":{},
			"tipo":"Damage",
			"nome":"Machados do poder",
			"arquivo":"machados",
			"damage":100,
			"tempo":{"atual":0,"maximo":15},
			"descricao":"[font_size=10]%s\nCriar um machado que fica rotacionando em você e dando dano em qualquer inimigo que ficar próximo[/font_size]",
			"melhorias":[
				{"grupo":"defesa","qtd":2},
			]
		},
	]
	var lista=[]
	for i in dados:
		lista.append(i.id)
		update(i.id,JSON.stringify(i))
	update("todas_skills",JSON.stringify(lista))
	var tmpClass={"vivo":true,"tempo_recupera_hp":{"atual":0,"maximo":10},"nivel":{"atual":1,"maximo":99},"vidas":{"atual":1,"maximo":99},"hp":{"atual":200,"maximo":300},"mp":{"atual":200,"maximo":200},
	"arma":{"tipo":"","damage":50,"qtd":{"atual":0,"maximo":-1},"tempo":{"atual":0.0,"maximo":0.5}},
	"extras":[],"atributos":{"mana":2,"cura":2,"defesa":2,"velocidade_ataque":2,},
	"reset":{
		"damage":50,
		"tempo":{"atual": 0.0,"maximo": 0.5},
		"atributos":{"cura": 2,"defesa": 2,"mana": 2,"velocidade_ataque": 2},
		"extras":[],
		"hp":{"atual": 300,"maximo": 300},
		"mp":{"atual": 300,"maximo": 300},
		"nivel":{"atual": 1,"maximo": 99},
		"tempo_recupera_hp":{"atual": 0,"maximo": 10}
		}
	}
	var classes=[
		{"nome":"Arqueiro","arma":"Arco básico"},
		{"nome":"Mago","arma":"Cajado básico"},
		{"nome":"Paladino","arma":"Espada básica"}
	]
	var fotos_homem=[]
	var fotos_mulher=[]
	for i in range(1,16):
		fotos_homem.append("h%03d" % [i])
		fotos_mulher.append("m%03d" % [i])
	fotos_homem.shuffle()
	fotos_mulher.shuffle()
	var nomes=[{"nome":"Arthur","sexo":"m"},{"nome":"Benjamin","sexo":"m"},{"nome":"Carlos","sexo":"m"},{"nome":"Daniel","sexo":"m"},{"nome":"Eduardo","sexo":"m"},{"nome":"Felipe","sexo":"m"},{"nome":"Gabriel","sexo":"m"},{"nome":"Henrique","sexo":"m"},{"nome":"Igor","sexo":"m"},{"nome":"João","sexo":"m"},{"nome":"Leonardo","sexo":"m"},{"nome":"Matheus","sexo":"m"},{"nome":"Nathan","sexo":"m"},{"nome":"Rafael","sexo":"m"},{"nome":"Thiago","sexo":"m"},{"nome":"Alice","sexo":"f"},{"nome":"Bianca","sexo":"f"},{"nome":"Camila","sexo":"f"},{"nome":"Daniela","sexo":"f"},{"nome":"Elisa","sexo":"f"},{"nome":"Fernanda","sexo":"f"},{"nome":"Gabriela","sexo":"f"},{"nome":"Helena","sexo":"f"},{"nome":"Isabela","sexo":"f"},{"nome":"Juliana","sexo":"f"},{"nome":"Larissa","sexo":"f"},{"nome":"Mariana","sexo":"f"},{"nome":"Natália","sexo":"f"},{"nome":"Rafaela","sexo":"f"},{"nome":"Tatiane","sexo":"f"},]
	nomes.shuffle()
	classes.shuffle()
	var posicao=0
	var contadorh=0
	var contadorm=0
	for i in range(0,15):
		var valor="player-%03d" % [i+1]
		var variavel=select(valor)
		if  typeof(variavel) != TYPE_DICTIONARY:
			var temp = tmpClass.duplicate()
			temp.id = valor
			temp.nome = nomes[i].nome
			temp.sexo = nomes[i].sexo
			if  nomes[i].sexo=="m":
				temp.avatar=fotos_homem[contadorh]
				contadorh += 1
			else:
				temp.avatar=fotos_mulher[contadorm]
				contadorm += 1
			temp.classe = classes[posicao].nome
			temp.arma.tipo = classes[posicao].arma
			posicao += 1
			posicao %= classes.size()
			update(valor,JSON.stringify(temp))

	#simular todas 
	var a=Database.select("pontos")
	if typeof(a) != TYPE_ARRAY:
		# ler todo os pontos do mapa e localizar mobs:Color(212,222,227,0)
		var marcadores=Comum.lerImagem(Color(255/255.0, 0/255.0, 255/255.0,1.0))
		#var marcadores=[{ "x": 272.0, "y": 178.0 }, { "x": 308.0, "y": 251.0 }, { "x": 187.0, "y": 313.0 }, { "x": 441.0, "y": 403.0 }, { "x": 491.0, "y": 321.0 }, { "x": 559.0, "y": 299.0 }, { "x": 692.0, "y": 137.0 }, { "x": 812.0, "y": 269.0 }, { "x": 941.0, "y": 340.0 }, { "x": 873.0, "y": 442.0 }, { "x": 725.0, "y": 514.0 }, { "x": 589.0, "y": 439.0 }, { "x": 463.0, "y": 488.0 }, { "x": 249.0, "y": 451.0 }, { "x": 351.0, "y": 373.0 }, { "x": 75.0, "y": 334.0 }, { "x": 16.0, "y": 248.0 }, { "x": 587.0, "y": 56.0 }, { "x": 695.0, "y": 27.0 }, { "x": 879.0, "y": 106.0 }, { "x": 793.0, "y": 189.0 }, { "x": 851.0, "y": 22.0 }, { "x": 1045.0, "y": 25.0 }, { "x": 1018.0, "y": 90.0 }, { "x": 948.0, "y": 31.0 }, { "x": 1047.0, "y": 185.0 }, { "x": 958.0, "y": 186.0 }, { "x": 1102.0, "y": 104.0 }, { "x": 1107.0, "y": 175.0 }, { "x": 1113.0, "y": 285.0 }, { "x": 1012.0, "y": 308.0 }, { "x": 1027.0, "y": 263.0 }, { "x": 1088.0, "y": 364.0 }, { "x": 1138.0, "y": 351.0 }, { "x": 1016.0, "y": 377.0 }, { "x": 904.0, "y": 409.0 }, { "x": 940.0, "y": 260.0 }, { "x": 815.0, "y": 368.0 }, { "x": 690.0, "y": 375.0 }, { "x": 554.0, "y": 386.0 }, { "x": 456.0, "y": 392.0 }, { "x": 537.0, "y": 467.0 }, { "x": 338.0, "y": 467.0 }, { "x": 340.0, "y": 510.0 }, { "x": 254.0, "y": 513.0 }, { "x": 78.0, "y": 533.0 }, { "x": 74.0, "y": 571.0 }, { "x": 40.0, "y": 557.0 }, { "x": 763.0, "y": 447.0 }, { "x": 873.0, "y": 530.0 }, { "x": 1042.0, "y": 486.0 }, { "x": 607.0, "y": 547.0 }]
		marcadores.shuffle()
		marcadores.shuffle()
		# listaremos todos os mobs que o jogo tem e vamos espalhar eles em nossa lista
		# para cada vez que uma wave subir de nível, iremos adicionar os mobs para ser
		# apresentado aos espectadores. A probabilidade é um fator que prativamente diz
		# o quao forte seria ele. além de ser escolhido, teremos a probabilidade de saber
		# se ele é realmente o escolhido, randomizamos um numero de 0-100 e se for menor que
		# sua probabilidade, não queremos este mob
		# Todos devem ser encontrados na pasta :res://scenes/mobs/<id>.tscn
		var mobs_disponiveis=[
			{"id":"mob_001","probabilidade":100},
			{"id":"mob_002","probabilidade":100},
			{"id":"mob_003","probabilidade":80},
			{"id":"mob_004","probabilidade":80},
			{"id":"mob_005","probabilidade":70},
			{"id":"mob_006","probabilidade":70},
			{"id":"mob_007","probabilidade":90},
			{"id":"mob_008","probabilidade":100},
			{"id":"mob_009","probabilidade":100},
		]  # não utilizado ainda.. incluir eles nas waves
		for i in range(0,10):
			var resultado=Database.select("ponto-%03d" % [i+1])
			if typeof(resultado) == TYPE_DICTIONARY:
				continue
			var tmp={
					"id":"ponto-001",
					"posicao":{"x":0,"y":0}, # posicao no mapa
					"finalizada":false,
					"base":200, # base dos mobs do mapa 
					"estagio":{"atual":0,"maximo":randi_range(3,6)},
					"mobs":{},
					"wave":{"atual":0,"maximo":randi_range(5,10)}, # quantidade de wave que este mapa tem
				}
			var estrutura={}
			for j in tmp.wave.maximo:
				tmp.mobs.set("%02d" % [j+1],{
					"nivel":1, # sem sentido
					"mobs":[
							{"id":"mob-001","probabilidade":100},
							{"id":"mob-002","probabilidade":100},
						]
					})
			tmp.estrutura = estrutura
			tmp.posicao.x = marcadores[i].x
			tmp.posicao.y = marcadores[i].y
			tmp.id = "ponto-%03d" % [i+1]
			Database.update("ponto-%03d" % [i+1],JSON.stringify(tmp))
		

	a=Database.select("cidades")
	if typeof(a) != TYPE_ARRAY:
		var nome_cidades=["Brisasol","Montelume","Auroraville","Pedraviva","Sombrosa","Valencór","Lagonauta","Florágua","Ventozelo","Estrelândia"]
		var marcadores=Comum.lerImagem(Color(200/255.0, 191/255.0, 131/255.0,1.0))
		marcadores.shuffle()
		marcadores.shuffle()
		nome_cidades.shuffle()
		nome_cidades.shuffle()
		var estr_marcadores=[]
		for i in range(0,5):
			var tmp={
					"id":"cidade-001",
					"nome":nome_cidades[i],
					"posicao":{"x":0,"y":0}, # posicao no mapa
				}
			tmp.posicao.x=marcadores[i].x
			tmp.posicao.y=marcadores[i].y
			tmp.id="cidade-%03d" % [i+1]
			estr_marcadores.append(tmp)
		Database.update("cidades",JSON.stringify(estr_marcadores))
