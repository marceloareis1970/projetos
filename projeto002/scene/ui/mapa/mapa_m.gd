extends Node2D

@onready var node: Control = $ui/n/t/Node
@onready var mapa_posicionado: TextureRect = $ui/n/t
@onready var combustivel: TextureRect = $ui/n/t/combustivel
@onready var label: Label = $ui/n/HBoxContainer/Label

var dados=null
var zoomt=50

func _ready() -> void:
	node.get_child(0).visible=false
	montar()

func _physics_process(delta: float) -> void:
	if dados != null:
		if Input.is_action_just_pressed("LEFT_MOUSE_BUTTON"):
			if dados.id != Comum.eu.estacao_espacial:
				Comum.eu.destino=dados
				label.text="Destino: %s" % [Comum.eu.destino.nome]

func montar():
	for i in node.get_children():
		if i.visible:
			i.queue_free()
	if ! Comum.eu.destino.is_empty():
		label.text="Destino: %s" % [Comum.eu.destino.nome]
	else:
		label.text="Destino: "
	var meio:Vector2=mapa_posicionado.size/2 
	var distancia_combustivel=int(Comum.eu.combustivel.atual / 10) * 200 
	combustivel.size=Vector2(distancia_combustivel,distancia_combustivel)
	combustivel.position= meio - combustivel.size / 2
	var minha_posicao=Comum.getMinhaEstacao()
	var vetor_minha_posicao= Vector2(minha_posicao.posicao.x,minha_posicao.posicao.y) 
	
	for i in Dados.sistema_solar.get(Comum.eu.sistema_solar).planetas:
		var temp=node.get_child(0).duplicate(true) # duplico o objeto que desejo
		var nova_sua_posicao = Vector2(i.posicao.x,i.posicao.y) - vetor_minha_posicao
		var nova_posicao=meio + nova_sua_posicao/zoomt - temp.size / 2
		if nova_posicao.x > mapa_posicionado.size.x or nova_posicao.y > mapa_posicionado.size.y or nova_posicao.y < 0 or nova_posicao.y < 0:
			continue
		temp.visible=true
		temp.tooltip_text=i.nome
		if temp.is_connected("mouse_entered",Callable(self,"_on_control_mouse_entered")):
			temp.disconnect("mouse_entered",Callable(self,"_on_control_mouse_entered"))
		temp.connect("mouse_entered",Callable(self,"_on_control_mouse_entered").bind(i))
		temp.position = nova_posicao
		node.add_child(temp)

func _on_control_mouse_entered(i) -> void:
	dados=i

func _on_control_mouse_exited() -> void:
	dados=null

func _on_control_gui_input(event: InputEvent) -> void:
	if dados == null:
		return
	#if not Input.is_action_just_pressed("LEFT_MOUSE_BUTTON"):
		#return
	## validar se está dentro da distância do hiper combustível
	#var origem = Vector2(Dados.sistema_solar.get(Comum.eu.sistema_solar).posicao.x,Dados.sistema_solar.get(Comum.eu.sistema_solar).posicao.y)
	#var destino = Vector2(dados.posicao.x,dados.posicao.y)
	#var distancia = origem.distance_to(destino)
	#var distancia_combustivel = int(Comum.eu.combustivel.atual / 200) * 50
	#if distancia_combustivel < distancia:
		#return
	#var combustivel_a_gastar=(distancia / 200) * 10
	#Comum.eu.hiper_espaco={"combustivel":combustivel_a_gastar,"destino":dados} 
	#queue_free()

func _on_button_2_pressed() -> void:
	zoomt += 10
	if zoomt > 100:
		zoomt = 100
	montar()

func _on_button_pressed() -> void:
	zoomt -= 10
	if zoomt < 50:
		zoomt= 50
	montar()

func _on_fechar_pressed() -> void:
	queue_free()
