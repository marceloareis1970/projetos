extends Node3D

@onready var no_player: Node = $player
@onready var no_scene_group: Node3D = $cidade/scene_group
@onready var no_identificaco: TextureRect = $hud/NinePatchRect/bg

var estrutura={}

func _ready() -> void:
	Comum.cidade=self
	Comum.onde_estou="cidade"
	Comum.campo=null
	# carregar a identificacao da cidade, como localizacao, etc
	var onde_estou=Database.select("onde_estou")
	if typeof(onde_estou) == TYPE_DICTIONARY:
		estrutura=onde_estou
	else:
		estrutura=Database.select("cidades")[0] # pegar a primeira cidade
		Database.update("onde_estou",JSON.stringify(estrutura)) # salvar em db
		
	
	pegarTodosColisores()
	identificacao()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("M"):
		var tmp=preload("res://scene/ui/mapa/ui_mapa.tscn").instantiate()
		add_child(tmp)

func pegarTodosColisores():
	Comum.colisores_excluidos.clear()
	for i in get_tree().get_nodes_in_group("walls_occluders"):
		Comum.colisores_excluidos.append(i.get_rid()) # pego todos os collides da cidade

func identificacao():
	if Comum.eu.is_empty():
		return
	no_identificaco.get_node("foto").texture=load("res://assets/fotos/%s.png" %[Comum.eu.avatar ])
	no_identificaco.get_node("classe").texture=load("res://assets/classes/%s.png" % [ Comum.eu.classe ])
	no_identificaco.get_node("nome").text = Comum.eu.nome
	
