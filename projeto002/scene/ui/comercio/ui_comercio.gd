extends CanvasLayer

@onready var v_box_container: VBoxContainer = $NinePatchRect/VBoxContainer/c2/VBoxContainer/H/scCompra/VBoxContainer
@onready var v_box_containerVenda: VBoxContainer = $NinePatchRect/VBoxContainer/c2/VBoxContainer/H/scVenda/VBoxContainer
@onready var cash: Label = $NinePatchRect/VBoxContainer/c1/cash

var itens=[]
var vendendo={}
var comprando={} # este arrais terão todos os valores que seleciono, <obj>:<qtdAtual>

func _ready() -> void:
	itens = Dados.produtos
	var planetas = Dados.sistema_solar.get(Comum.eu.sistema_solar).planetas
	for i in planetas:
		if i.id == Comum.eu.estacao_espacial:
			itens=i.produtos
			break
	v_box_container.get_child(0).visible=false
	v_box_containerVenda.get_child(0).visible=false
	montar()

func montar():
	cash.text = "Cash:%03d" % [ Comum.eu.cash ]
	montar_compra()
	montar_vender()

func montar_compra():
	cash.text = "Cash:%.02f" % [ Comum.eu.cash ]
	comprando.clear()
	for i in v_box_container.get_children():
		if i.visible:
			i.queue_free()
	for i in itens:
		var tmp=v_box_container.get_child(0).duplicate()
		tmp.visible=true
		tmp.get_node("h/v/produto").text = i.descricao
		tmp.get_node("h/v/preco").text="Valor Unitário: %.02f" % [ i.preco_compra ]
		tmp.get_node("h/v/h/qtd").connect("value_changed",Callable(self,"DisplayValoresCompra").bind(
							i.id,
							i.preco_compra,
							tmp.get_node("h/v/h/display"),
		))
		tmp.get_node("h/v/h/btmenos").connect("pressed",Callable(self,"btmenos").bind(
							tmp.get_node("h/v/h/qtd")  # mudar apenas a qtd na régua que dispara a rotina de change dela
							))
		tmp.get_node("h/v/h/btmais").connect("pressed",Callable(self,"btmais").bind(
							tmp.get_node("h/v/h/qtd")  # mudar apenas a qtd na régua que dispara a rotina de change dela
							))
		tmp.get_node("h/v/h/btconfirmar").connect("pressed",Callable(self,"btConfirmarCompras").bind(i)) # confirma a compra
		var tamanho
		tmp.get_node("h/v/h/qtd").max_value==0
		tmp.get_node("h/v/h/btmais").visible=false
		tmp.get_node("h/v/h/btmenos").visible=false
		tmp.get_node("h/v/h/btconfirmar").visible=false
		tmp.get_node("h/v/h/qtd").visible=false
		tmp.get_node("h/v/h/display").visible=false
		if float(i.preco_compra) > 0.00:
			tamanho=int(Comum.eu.cash/i.preco_compra)
			if tamanho > 0:
				tmp.get_node("h/v/h/display").visible=true
				tmp.get_node("h/v/h/qtd").max_value=tamanho
				tmp.get_node("h/v/h/btmais").visible=true
				tmp.get_node("h/v/h/btmenos").visible=true
				tmp.get_node("h/v/h/btconfirmar").visible=true
				tmp.get_node("h/v/h/qtd").visible=true
		v_box_container.add_child(tmp)
		
func DisplayValoresCompra(valor,id,preco_compra,objeto_atualizar):
	var tmp= valor * preco_compra 
	objeto_atualizar.text = "%02d/%.02f" %[ valor , tmp  ]
	comprando.set(id,{"valor":tmp,"qtd":valor})

func btmenos(obj):
	obj.value -= 1

func btmais(obj):
	obj.value += 1

func btConfirmarCompras(i):
	if not comprando.has(i.id):
		return
	if Comum.addBag({"id":i.id,"qtd":comprando.get(i.id).qtd}):
		Comum.eu.cash -= comprando.get(i.id).valor
		montar()

func montar_vender():
	vendendo.clear()
	for i in v_box_containerVenda.get_children():
		if i.visible:
			i.queue_free()
	for j in Comum.eu.bag.itens:
		var tmp=v_box_containerVenda.get_child(0).duplicate()
		var i=pegarItemById(j.id)
		if i == null:
			continue
		tmp.visible=true
		tmp.get_node("h/v/produto").text = i.descricao
		tmp.get_node("h/v/preco").text="Valor Unitário: %.02f" % [ i.preco_venda ]
		tmp.get_node("h/v/h/qtd").connect("value_changed",Callable(self,"DisplayValoresVenda").bind(
							i.id,
							i.preco_venda,
							tmp.get_node("h/v/h/display"),
		))
		tmp.get_node("h/v/h/btmenos").connect("pressed",Callable(self,"btmenosVenda").bind(
							tmp.get_node("h/v/h/qtd")  # mudar apenas a qtd na régua que dispara a rotina de change dela
							))
		tmp.get_node("h/v/h/btmais").connect("pressed",Callable(self,"btmaisVenda").bind(
							tmp.get_node("h/v/h/qtd")  # mudar apenas a qtd na régua que dispara a rotina de change dela
							))
		tmp.get_node("h/v/h/btconfirmar").connect("pressed",Callable(self,"btConfirmarVenda").bind(i)) # confirma a compra
		if float(i.preco_venda) > 0.00:
			tmp.get_node("h/v/h/qtd").max_value=j.qtd
		v_box_containerVenda.add_child(tmp)
		
func DisplayValoresVenda(valor,id,preco_compra,objeto_atualizar):
	var tmp=valor * preco_compra
	objeto_atualizar.text = "%02d/%.02f" %[ valor , tmp  ]
	vendendo.set(id,{"valor":tmp,"qtd":valor})

func btmenosVenda(obj):
	obj.value -= 1

func btmaisVenda(obj):
	obj.value += 1

func btConfirmarVenda(i):
	if not vendendo.has(i.id):
		return
	if Comum.DelBag({"id":i.id,"qtd":vendendo.get(i.id).qtd}):
		Comum.eu.cash += vendendo.get(i.id).valor
		Comum.addItemComercio({"id":i.id,"qtd":vendendo.get(i.id).qtd})
		montar()
	
func _on_button_pressed() -> void:
	Comum.player_estacao=true
	queue_free()

func pegarItemById(id):
	for i in itens:
		if i.id==id:
			return i
	return null
