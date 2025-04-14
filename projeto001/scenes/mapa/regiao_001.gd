extends Node3D
# para gerar estes pontos, eu simplesimente usei a tecla de espaco no player e fui saindo
# e pressionando space e armazenava a global_position em um array.
# Com uma outra teclha eu dei um print_debug desta variável e depois trouxe para cá.
# Por último comentei as linhas e deixei lá pois poderia utilizar para marcar outra coisa qualquer
var mobs_spawn=[
	{"x": 15.3394775390625,"y": 1.00072383880615,"z": -7.98836278915405},
	{"x": 17.2200813293457,"y": 1.00072383880615,"z": -20.5702419281006},
	{"x": 25.698881149292,"y": 1.00072383880615,"z": -30.5057315826416},
	{"x": 39.1673736572266,"y": 1.00072383880615,"z": -25.1944808959961},
	{"x": 43.8383522033691,"y": 1.00072383880615,"z": -41.3515472412109},
	{"x": 21.3839645385742,"y": 1.00072383880615,"z": -45.2169189453125},
	{"x": 6.17269420623779,"y": 1.00072383880615,"z": -38.5075378417969},
	{"x": 6.54634666442871,"y": 1.00072383880615,"z": -23.9518699645996},
	{"x": -13.0508337020874,"y": 1.00072383880615,"z": -19.0473690032959},
	{"x": -11.9199447631836,"y": 1.00072383880615,"z": -31.9923839569092},
	{"x": -26.849609375,"y": 1.00072383880615,"z": -43.3348655700684},
	{"x": -39.1878356933594,"y": 1.00072383880615,"z": -36.4837532043457},
	{"x": -32.4033699035645,"y": 1.00072383880615,"z": -21.3284473419189},
	{"x": -39.368579864502,"y": 1.00072383880615,"z": -6.81345844268799},
	{"x": -30.6992263793945,"y": 1.00072383880615,"z": 3.46772122383118},
	{"x": -36.3026733398438,"y": 1.00072383880615,"z": 18.8658828735352},
	{"x": -24.6954193115234,"y": 1.00072383880615,"z": 32.8844871520996},
	{"x": -14.9130992889404,"y": 1.00072383880615,"z": 27.5531749725342},
	{"x": -12.3950500488281,"y": 1.00072383880615,"z": 15.9084548950195},
	{"x": 2.08370661735535,"y": 1.00072383880615,"z": 18.0201721191406},
	{"x": 1.64916360378265,"y": 1.00072383880615,"z": 29.8367557525635},
	{"x": 12.5564193725586,"y": 1.00072383880615,"z": 32.5049629211426},
	{"x": 23.0517196655273,"y": 1.00072383880615,"z": 22.3428440093994},
	{"x": 35.5035743713379,"y": 1.00072383880615,"z": 16.0998210906982}
]
var utilizados:Array=[]
var origem:Vector3
func _ready() -> void:
	Comum.eu.pode_atirar=true # liberado para atirar
	var tmp=preload("res://scenes/portal/portal_cidade.tscn").instantiate() # incializa o portal
	add_child(tmp)  # colocaremos na tela
	tmp.destino="mapa_cidade"  # qual mapa iremos ir ao ativar ele
	
func _physics_process(delta: float) -> void:
	if origem.distance_to(Comum.player.global_position) > 15: # esta parte da rotina faz com que analise todos os pontos de respawn de mobs apenas qndo a condicao for satisfeita
		origem = Comum.player.global_position # atualizo a posicao analisada
		for i in mobs_spawn: # iteracao em todas as posicoes registradas de mobs deste mapa
			var a=Vector3(i.x,i.y,i.z) # converto em um VETOR 3
			if a.distance_to(Comum.player.global_position) <= 20: # se a distancia for proximo do player.. analise
				if utilizados.find("%s_%s_%s" % [a.x,a.y,a.z]) == -1: # verifica se já está on este slot. Todo criado, vai direto para a variavel utilizados
					utilizados.append("%s_%s_%s" % [a.x,a.y,a.z]) # coloca na listagem como á feito
					var tmp=preload("res://scenes/mob/spawn/spawn_mobs.tscn").instantiate() # instancia o spawn de mobs
					tmp.position = a # colocaremos o spawn no lugar correto
					Comum.mapa.addObjeto(tmp,"inimigos")
