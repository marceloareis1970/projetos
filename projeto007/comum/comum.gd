extends Node


var mapa=null
var player=null
var campo=null
var cidade=null

var onde_estou="" # para informar se estamos na cidade, campo, etc

var meus_players={}
var colisores_excluidos=[] # collision entre visao e o player.
var eu={}


var lista_de_skills_dropaveis=[
	{
		"id":"skill_drop_001",
		"nome":"Ataque da meia-noite",
		"tipo":"magia",
		"tempo":{"atual":3,"countdown":5},
		"descricao":"[font_size=10]%s\n Uma bola de gelo atinge os inimigos, por 3s. Intervalo de 5s[/font_size]",
		"melhorias":[
			{"grupo":"mana","qtd":2},
			{"grupo":"cura","qtd":2},
			{"grupo":"defesa","qtd":2},
			{"grupo":"velocidade_ataque","qtd":2},
		]
	},
	{
		"id":"skill_drop_002",
		"tipo":"magia",
		"nome":"Ataque do meia-dia",
		"tempo":{"atual":3,"countdown":5},
		"descricao":"[font_size=10]%s\n Uma bola de fogo atinge os inimigos, por 3s. Intervalo de 5s[/font_size]",
		"melhorias":[
			{"grupo":"mana","qtd":2},
			{"grupo":"cura","qtd":2},
			{"grupo":"defesa","qtd":2},
			{"grupo":"velocidade_ataque","qtd":2},
		]
	},
	{
		"id":"skill_drop_003",
		"tipo":"magia",
		"nome":"Poder aquático",
		"tempo":{"atual":3,"countdown":5},
		"descricao":"[font_size=10]%s\n lancas dáguas saem em direção aos inimigos, por 3s. Intervalo de 5s[/font_size]",
		"melhorias":[
			{"grupo":"mana","qtd":2},
			{"grupo":"cura","qtd":2},
			{"grupo":"defesa","qtd":2},
			{"grupo":"velocidade_ataque","qtd":2},
		]
	},
]

func escolheuCarta(carta:Dictionary) -> void:
	for i in carta.melhorias:
		var tmpvalor=i.qtd
		if eu.atributos.has(i.grupo):
			tmpvalor += float(eu.atributos.get(i.grupo))
		if ["hp_maximo"].find(i.grupo) >-1:
			if i.grupo == "hp_maximo":
				eu.hp.maximo += i.qtd
				Comum.campo.atualizaStatus()
		else:
			eu.atributos.set(i.grupo, tmpvalor + i.qtd )
	var tem:bool=false
	for i in eu.extras:
		if i.id == carta.id:
			i.damage += randi_range(1,3)
			if i.has("mana"):
				i.mana += randi_range(1,3)
			tem=true
			break
	if not tem:
		eu.extras.append(carta)

func getImageById(id:String):
	if FileAccess.file_exists("res://assets/itens/%s.png" % [id]):# a imagem existe?
		return load("res://assets/itens/%s.png" % [id])# retorna a imagem da material
	else:
		return null

func lerImagem(target_color:Color)->Array:
	# Carregar a imagem
	var image = Image.new()
	var err=image.load("res://assets/images/mapa.png")  # Certifique-se de que o caminho da imagem está correto
	if err != OK:
		print_debug("Erro na imagem")
		return []
	# Obter o tamanho da imagem
	var width = image.get_width()
	var height = image.get_height()
	var pontos = []
	for x in range(width):
		for y in range(height):
			var pixel_color = image.get_pixel(x, y)
			if pixel_color == target_color:
				pontos.append({"x":x,"y": y})

	return pontos
