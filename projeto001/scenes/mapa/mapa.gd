extends Node3D
@onready var no_marca: Node = $marca
@onready var no_mapa: Node3D = $mapa
@onready var no_tiros: Node = $tiros
@onready var no_inimigos: Node = $inimigos
@onready var no_player: Node = $player


var mapa_padrao="mapa_cidade"

func _ready() -> void:
	Comum.mapa=self  # apontamos para a variavel global (por referencia) o proprio mapa, assim poderemos referenciar o objeto através de comum
	Comum.eu=Database.read("eu")
	Comum.npc_marquisa_construir=Database.read("npc_marquisa_construir")
	carregaMapa(mapa_padrao) # funcoa que carrega o mapa inicialemnte

func addObjeto(obj,pasta,analise=false): # a função permite que analisemos se existe algo na pasta e permite colocar um obj na pasta desejada
	if analise: # se queremos analisar
		for i in get_node(pasta).get_children(): # faremos uma checagem completa em todos os objetos desta pasta
			i.queue_free() # queue_free se existir objeto
	get_node(pasta).add_child(obj) #por ultimo, adicionamos a esta pasta o objeto novo

func addMarca(obj):
	addObjeto(obj,"marca",true) # aponta para a função genérica

func removerSpawnMobsDaLista(nome:String)->void:
	var onde=no_mapa.get_child(0).utilizados.find(nome) # tenta localizar onde está o spawn de mobs na lista
	if onde == -1: # se não achou, retorna
		return
	no_mapa.get_child(0).utilizados.remove_at(onde) # se achou, remove da lista. Desta forma ele poder ser "respawnado" porqu =e não esta´an lista

func carregaMapa(smapa:String)->void:
	for i in no_mapa.get_children(): # iteracao na pasta de mapas
		i.queue_free() #vamos remover todos
	for i in no_tiros.get_children():
		i.queue_free() #vamos remover todos
	for i in no_inimigos.get_children():
		i.queue_free() #vamos remover todos
	for i in no_marca.get_children():
		i.queue_free() #vamos remover todos
	var tmp=load("res://scenes/mapa/%s.tscn" % [ smapa ]).instantiate() # vamos iniciar com o mapa descrito na variavel
	no_mapa.add_child(tmp) # adicionando ele na tela
	# agora iremos carregar nosso player
	for i in no_player.get_children(): # itracao para pegar todos os player do nosso mapa e destruir eles
		i.queue_free() # dá o goodi bái pra cada um
	var the_player=preload("res://scenes/player/no_player.tscn").instantiate() # instanciamos um novo player
	the_player.position += Vector3.UP * 3
	no_player.add_child(the_player)
