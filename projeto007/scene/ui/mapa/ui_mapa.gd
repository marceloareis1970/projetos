extends CanvasLayer

@onready var no_onde_estou: TextureRect = $Control/onde_estou
@onready var mob_cidade: TextureRect = $Control/cidade
@onready var mob_mobs: TextureRect = $Control/mobs
@onready var no_posicao: Control = $ColorRect/NinePatchRect/VBoxContainer/TextureRect/Control
@onready var no_modelos: Control = $Control


var marcacoes=[]
var destino=null
var ativo:bool=false

func _ready() -> void:
	get_tree().paused = true
	for i in no_modelos.get_children(): # garantir que todos destes nós estarão invisiveis
		i.visible=false
	montar()

func _physics_process(delta: float) -> void:
	if ativo:
		if Input.is_action_just_pressed("LFB"):
			var tmp=preload("res://scene/campo/campo.tscn").instantiate()
			tmp.estrutura=destino
			Comum.mapa.carregarMapa(tmp)

func montar():
	for i in no_posicao.get_children():
		i.queue_free()
	var registros=Database.select("ponto-","",true)
	var keys=registros.keys() # pegamos todos os pontos separadamentes e listamos todos as chaves
	for i1 in keys: # de posse cada chave
		var i=registros.get(i1) # pegamos o i (que é a estrutura do mapa)
		var tmp=mob_mobs.duplicate()
		tmp.visible=true # sem necessidade pq o control que está invisivel e nao o modelo
		tmp.position=Vector2(i.posicao.x,i.posicao.y)
		tmp.get_node("g").columns = i.estagio.maximo
		if i.estagio.atual < i.estagio.maximo:
			for k in i.estagio.maximo:
				var celula=tmp.get_node("g").get_child(0).duplicate()
				celula.visible=true
				tmp.get_node("g").add_child(celula)
				if k < i.estagio.atual: # carregar as imagens brancas para indicar qntas já foram
					celula.get_node("t").texture=load("res://assets/images/bar.png")
		else:
			tmp.mouse_default_cursor_shape = Control.CursorShape.CURSOR_FORBIDDEN
		tmp.connect("mouse_entered",Callable(self,"_on_mobs_mouse_entered").bind(i,tmp))
		tmp.connect("mouse_exited",Callable(self,"_on_mobs_mouse_exited").bind(tmp))
		no_posicao.add_child(tmp)
	#cidades
	registros=Database.select("cidades")
	for i in registros:
		var tmp=mob_cidade.duplicate()
		tmp.visible=true # sem necessidade pq o control que está invisivel e nao o modelo
		tmp.position=Vector2(i.posicao.x,i.posicao.y)
		tmp.tooltip_text = i.nome
		no_posicao.add_child(tmp)
	#onde estou
	registros=Database.select("onde_estou")
	var tmp=no_onde_estou.duplicate()
	tmp.position=Vector2(registros.posicao.x,registros.posicao.y)
	tmp.visible=true
	no_posicao.add_child(tmp)


func _on_texture_button_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_mobs_mouse_exited(objeto) -> void:
	destino=null
	ativo=false
	(objeto as TextureRect).z_index=0 # reposicionar o objeto

func _on_mobs_mouse_entered(estrutura_ponto,objeto) -> void:
	if estrutura_ponto.estagio.atual < estrutura_ponto.estagio.maximo:
		ativo=true
		destino=estrutura_ponto
	(objeto as TextureRect).z_index=1 #trazer o objeto para frente
