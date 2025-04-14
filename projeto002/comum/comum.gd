extends Node

var game=null
var mapa=null
var player=null

var distancia:float = 0
var origem:float = 0
var warp:bool=false # se true, é mostrada as estrelas correndo rápido
var mob:bool=false # se true, é uma área com mobs
var wave:int=0 # numero de wave de mobs vamos ter
var station:int = 0 # 0 -- espaco, 1-- posicionando até o centro da tela 2--a estacao aparecerá
var player_estacao:bool = true # true - pode mover false - nao move
# esta variavel, que é você, pode ser gravada em algum lugar, seja local ou web e recuperado, 
# fazendo assim que, ao sair, vc mantenha gravado sua posicao atual.
var eu={
	"cash":200,
	"vivo":true,
	"cash_extra":false,
	"sistema_solar":"sistema-solar-001",
	"estacao_espacial":"sistema-solar-001-001",
	"destino":{},
	"destino_hiperdriver":{},
	"blindagem":{"id":"blind-mk-01","atual":135,"maximo":200,"reforco":20},
	"combustivel":{"id":"tq-padrao-01","atual":20,"maximo":200},
	"hiperdrive_combustivel":{"id":"hd-01","atual":50,"maximo":200},
	"hiper_espaco":{},
	"bag":{
		"size":10,
		"itens":[
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
			{"id":"","qtd":0},
		]
	}
}

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

func pegarItemById(id):
	for i in Dados.produtos:
		if i.id == id:
			return i
	return null

func addItemComercio(item):
	for i in Dados.produtos:
		if i.id == eu.estacao_espacial:
			for j in i.itens:
				if j.id == item.id:
					j.qtd += item.qtd

func atualizarPrecos():
	var itens = Dados.produtos
	var planetas = Dados.sistema_solar.get(Comum.eu.sistema_solar).planetas
	var resultado=[]
	randomize()
	for i in planetas:
		if i.produtos.size()>0:
			continue
		i.produtos = itens.duplicate(true)  # uma duplificacao sem referência
		for j in i.produtos:
			var oferta=randf_range(200,600)
			var lucro=0.2
			var tmp_preco=j.preco_compra
			j.preco_compra = float(calcularPreco(i.populacao,i.demanda,tmp_preco,oferta))
			tmp_preco="%.02f" % [j.preco_compra - j.preco_compra * lucro]
			j.preco_venda = float(tmp_preco)
	

func calcularPreco(populacao,demanda,custoBase,oferta,lucro=1):
	var preco = ((( demanda *  populacao) +  custoBase) / oferta);
	return  "%.02f" % [ preco ]

func getEstacaoNome():
	var planetas = getMinhaEstacao()
	if planetas.is_empty():
		return "??"
	return planetas.nome

func getMinhaEstacao():
	var planetas = Dados.sistema_solar.get(Comum.eu.sistema_solar).planetas
	for i in planetas:
		if i.id == Comum.eu.estacao_espacial:
			return i
	return {}

func SaveFile():
	var file = FileAccess.open("res://dados.json", FileAccess.WRITE_READ)
	var salvar={"a":eu,"b":Dados.sistema_solar}
	file.store_string(JSON.stringify(salvar))
	file = null

func consertarNave():
	var custo=(Comum.eu.blindagem.maximo - Comum.eu.blindagem.atual) * 3.0
	return custo
