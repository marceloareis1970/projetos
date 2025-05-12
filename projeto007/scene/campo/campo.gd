extends Node3D

@onready var no_mobs: Node = $mobs
@onready var no_next_wave: Label = $ui/next_wave
@onready var no_timer: Timer = $Timer
@onready var no_ui: CanvasLayer = $ui
@onready var no_popup: TextureProgressBar = $ui/TextureProgressBar
@onready var no_gui: Node = $telas
@onready var no_n: StaticBody3D = $bloqueios/N
@onready var no_s: StaticBody3D = $bloqueios/S
@onready var no_l: StaticBody3D = $bloqueios/L
@onready var no_o: StaticBody3D = $bloqueios/O
@onready var no_portal: TextureButton = $ui/Control/TextureButton
@onready var no_display_wave: Label = $ui/TextureProgressBar/Label


var estrutura={}
var contador_tempo:int=10
var contador_:float=10 # para iniciar sem mobs para ficar fácil
var tamanho_mapa=98
var temos_boss:bool=false
var ativar_chamador:bool=false
var lista_mob=[] # vamos alimentando toda vez q mudar-mos o nivel da wave e add os mobs aqui

func _ready() -> void:
	get_tree().paused = false
	Comum.onde_estou = "campo"
	Comum.campo = self
	Comum.eu.nivel.atual = 1 # restamos o nivel do player
	Comum.eu.nivel.maximo = 99 # maximo que pode ter
	no_popup.max_value = calculaBarraXPValor( 1 )
	no_popup.value = 0
	no_n.position.x = tamanho_mapa
	no_s.position.x =- tamanho_mapa
	no_l.position.z = tamanho_mapa
	no_o.position.z =- tamanho_mapa
	addMobsNovosNaLista()	# add os primeiros mobs a lista
	no_timer.start()

func _physics_process(delta: float) -> void:
	barreiraInvisivel()
	contador_ -= delta
	if contador_ < 0: # indica que devemos inserir mais mobs
		contador_ = 5
		for i in range(0,5):
			addNewMob()

func addNewMob() -> bool:
	var contar=5 # numero de tentativas
	var testar:Dictionary # mob escolhido ID e probabilidade deste mob sair
	var lAchou:bool=false # se o mob foi localizado
	while contar > 0 and not lAchou and lista_mob.size()>0:
		contar -= 1 # decrementa numeros de tentativas
		var rand=randi_range(0,lista_mob.size() -1 ) # escolhe um randomicamente
		testar=lista_mob[rand] # escolhe randomicamente o mob
		rand=randi_range(0,100)
		if rand >= testar.probabilidade: # testa se irá aparecer na probabilidade definida para ele
			lAchou=true # indica que achou
			break # sai do loop
	if lAchou:
		return false # indica que não achou
	# fix: apenas para evitar erro
	if ["mob_002","mob_002"].find(testar.id) == -1:	#remover
		testar.id=["mob_002","mob_002"][randi_range(0,1)] #remover
	var mob=load("res://scene/mob/%s.tscn" % [ testar.id ]).instantiate()
	var raio=randf_range(15,20) # raio de aparicao
	var angulo=randf_range(0,360) # onde ser a aparicao
	var posicao = Comum.player.global_position
	# verificar aqui se este mob pertence a alguma quest e se sim, qual  item e porcentagem de drop dele
	# mob.itens_drop_extras.append({"id":"drop_050","porcentagem":10})
	posicao.x += cos(deg_to_rad(angulo)) * raio # calcula a posicao do mob
	posicao.z += sin(deg_to_rad(angulo)) * raio # calcula a posicao do mob
	no_mobs.add_child(mob) # adiciona o mob ao mapa
	mob.global_position = posicao # atualiza a posicao verdadeira
	return true # retorna verdeiro indicando que foi criado um mob

func barreiraInvisivel() -> void:
	#é uma barreira invisivel, um quadrado que acompanha o player
	# se existir altura, basta colocar a representacao Y igual ao do player
	no_n.position.z=Comum.player.position.z
	no_s.position.z=Comum.player.position.z
	no_l.position.x=Comum.player.position.x
	no_o.position.x=Comum.player.position.x

func _on_timer_timeout() -> void:
	if temos_boss: # desativa probabilidade de melhorias no player
		return
	contador_tempo -= 1
	if contador_tempo <= 0:
		estrutura.wave.atual += 1
		# 1. Se as waves chegaram até o final, ativar o boss automaticamente
		if estrutura.wave.atual > estrutura.wave.maximo and not temos_boss:
			estrutura.wave.atual=estrutura.wave.maximo
			no_next_wave.text = ""
			addBoss()
			return 
		# 2. Se contagem de wave for maior que 70%, colocar ativador no meio da tela
		if estrutura.wave.atual >= estrutura.wave.maximo * 0.7 and not ativar_chamador:
			ativar_chamador=true
			var tmp=preload("res://scene/ativador/ativador_chamada.tscn").instantiate()
			add_child(tmp)
		contador_tempo = 15
	# transforma os segundo em formato de 00:00
	var tempo=Time.get_datetime_dict_from_unix_time(contador_tempo)
	if contador_tempo > 10:
		no_next_wave.text = "%02d:%02d\n%02d/%02d" % [ tempo.minute, tempo.second,estrutura.wave.atual,estrutura.wave.maximo ]
	else:
		if estrutura.wave.atual == estrutura.wave.maximo:
			no_next_wave.text = "%02d:%02d\n%02d/%02d" % [ tempo.minute, tempo.second,estrutura.wave.atual,estrutura.wave.maximo ]
		else:
			no_next_wave.text =  "%02d:%02d\n%02d/%02d\nproxima onda de inimgos" % [ tempo.minute, tempo.second,estrutura.wave.atual,estrutura.wave.maximo ]
	no_timer.start()

func atualizaStatus() -> void:
	no_display_wave.text="%02d/%02d" % [Comum.eu.nivel.atual,Comum.eu.nivel.maximo]
	no_ui.get_node("Control/bg/level").text = "%02d" % [ estrutura.wave.atual ] # visualizando quantas waves já tem
	no_ui.get_node("Control/bg/vidas").text = "%02d" % [ Comum.eu.vidas.atual ] # visualizando quantas vidas temos
	no_ui.get_node("Control/hp").max_value = Comum.eu.hp.maximo
	no_ui.get_node("Control/hp").value = Comum.eu.hp.atual
	no_ui.get_node("Control/mp").max_value = Comum.eu.mp.maximo
	no_ui.get_node("Control/mp").value = Comum.eu.mp.atual

func addFoto() -> void:
	no_ui.get_node("Control/bg/foto").texture = load("res://assets/fotos/%s.png" %[Comum.eu.avatar])

func addXP(xp) -> void:
	if temos_boss: # quando inserimos o boss não mais subimos o nivel da wave
		return
	var montarTelaEscolha:bool=false
	no_popup.value += xp
	if no_popup.value == no_popup.max_value:
		Comum.eu.nivel.atual += 1
		if Comum.eu.nivel.atual > Comum.eu.nivel.maximo:
			Comum.eu.nivel.atual=Comum.eu.nivel.maximo
		montarTelaEscolha=true
		no_popup.value=0
		no_popup.max_value=calculaBarraXPValor(1)
		atualizaStatus()
	if montarTelaEscolha:
		addMobsNovosNaLista()
		if no_gui.get_child_count() == 0:
			#fix: problema de duplicidade encontrado aqui em algumas situações (sem analisar ainda como evitar )
			var tmp=preload("res://scene/ui/escolhas/escolhas.tscn").instantiate()
			no_gui.add_child(tmp)
		else:
			pass

func calculaBarraXPValor(nivel:int):
	# a base de hp do inimigo cresce de acordo com o nível do mapa
	var tmp={"fator":1.5,"base":int(100 * int(Comum.eu.nivel.atual) + (100 * int(Comum.eu.nivel.atual))/2.0)}
	if tmp.base == 0:
		tmp.base=100
	return tmp.base * pow(nivel , tmp.fator)

func calcularHPInimigo(base_hp:int):
	var instrucoes_mapa={
		"nivel":1, # nivel deste mapa
		"difficulty_factor":0.3,
		"resistance_factor":10,
		"posicao":{"x":0,"y":0}, # posicao do mapa no mapa mundi
		"ultimo_respawn":Time.get_datetime_dict_from_system() # data do ultimo respawn dele
	}
	var map_level = instrucoes_mapa.nivel
	var player_level = int(Comum.eu.nivel.atual)
	var difficulty_factor = instrucoes_mapa.difficulty_factor
	var resistance_factor = instrucoes_mapa.resistance_factor
	return base_hp * (1 + (player_level * difficulty_factor)) + (map_level * resistance_factor)

func addMobsNovosNaLista():
	var ind="%02d" % [estrutura.wave.atual + 1]
	if estrutura.mobs.has(ind):
		var ids=[]
		for i in lista_mob:
			ids.append(i.id)
		for i in estrutura.mobs.get(ind).mobs:
			if ids.find(i.id) == -1:
				ids.append(i.id)
				lista_mob.append(i)

func addBoss(nocentro:bool=true):
	temos_boss=true # indica que incluimos um  boss no campo somente
	var tmp=load("res://scene/mob/boss_001.tscn").instantiate()
	if not nocentro:
		var raio=randf_range(15,20) # raio de aparicao
		var angulo=randf_range(0,360) # onde ser a aparicao
		var posicao = Comum.player.global_position # pega referencia voce
		posicao.x += cos(deg_to_rad(angulo)) * raio # calcula a posicao do mob
		posicao.z += sin(deg_to_rad(angulo)) * raio # calcula a posicao do mob
		tmp.position=posicao
	add_child(tmp)


func _on_texture_button_pressed() -> void:
	no_portal.disabled = true
	Comum.onde_estou = ""
	var tmp = load("res://scene/cidade/cidade.tscn").instantiate()
	Comum.mapa.carregarMapa(tmp)
	queue_free()

func AddNivelMapa():
	var tmp=Database.select(estrutura.id)
	tmp.estagio.atual += 1
	Database.update(estrutura.id,JSON.stringify(tmp))
