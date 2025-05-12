extends Node3D

@onready var no_tiros: Node = $tiros
@onready var no_mobs: Node = $mobs
@onready var no_mapa: Node = $mapa
@onready var no_player: Node = $player
@onready var no_ui: Node = $ui


func _ready() -> void:
	Comum.mapa=self # criamos o apontador do mapa pra  a global Comum.mapa, assim, podemos recuperar em qualquer .gd
	# carregar a cidade inicial
	var tmp = preload("res://scene/cidade/cidade.tscn").instantiate()
	no_mapa.add_child(tmp)
	#inicializar na taberna
	var carregar_player=Database.select("player_atual") # se existir um player que usou anteriormente
	if typeof(carregar_player) != TYPE_DICTIONARY: #não existe, então começe na taverna
		var temp=preload("res://scene/ui/escolhe_player/ui_escolhe_player.tscn").instantiate()
		no_ui.add_child(temp)
	else:
		Comum.eu = carregar_player
		var tmp2=preload("res://scene/player/no_player.tscn").instantiate()
		tmp2.position = Vector3(-62.781,0.1,-1.416) # na frente da taverna
		no_player.add_child(tmp2)
	
func carregarPlayer():
	for i in no_player.get_children():
		i.queue_free()
	# carregar o player
	var tmp=preload("res://scene/player/no_player.tscn").instantiate()
	no_player.add_child(tmp)

func carregarMapa(qual,posicao=Vector3.ZERO):
	for i in no_mapa.get_children():
		i.queue_free()
	for i in no_mobs.get_children():
		i.queue_free()
	for i in no_tiros.get_children():
		i.queue_free()
	for i in no_player.get_children():
		i.queue_free()

	#carregar o player na posicao correta
	var tmp=load("res://scene/player/no_player.tscn").instantiate()
	tmp.position=posicao
	no_player.add_child(tmp)
	# add o mapa correto
	no_mapa.add_child(qual)

func addTiro(obj) -> void:
	no_tiros.add_child(obj) # adicionamos a um no especifico, para facilitar nas análises
