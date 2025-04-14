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
			Comum.eu.destino_hiperdriver=dados
			label.text="Constelação: %s" % [Comum.eu.destino_hiperdriver.nome]

func montar():
	for i in node.get_children():
		if i.visible:
			i.queue_free()
	if ! Comum.eu.destino_hiperdriver.is_empty():
		label.text="Constelação: %s" % [Comum.eu.destino_hiperdriver.nome]
	else:
		label.text="Constelação: "
	var meio:Vector2=mapa_posicionado.size/2 
	var distancia_combustivel=int(Comum.eu.hiperdrive_combustivel.atual / 10) * 2000 
	combustivel.size=Vector2(distancia_combustivel,distancia_combustivel)/zoomt
	combustivel.position= meio - combustivel.size / 2
	var minha_posicao=Comum.getMinhaEstacao()
	var vetor_minha_posicao= Vector2(minha_posicao.posicao.x,minha_posicao.posicao.y) 
	for i1 in Dados.sistema_solar.keys():
		var i=Dados.sistema_solar.get(i1)
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
