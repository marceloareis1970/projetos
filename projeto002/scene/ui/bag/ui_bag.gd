extends CanvasLayer

@onready var v_box_container: VBoxContainer = $NinePatchRect/VBoxContainer/c2/VBoxContainer/H/scCompra/VBoxContainer
@onready var cash: Label = $NinePatchRect/VBoxContainer/c1/cash



func _ready() -> void:
	v_box_container.get_child(0).visible=false # esse é o modelo a ser duplicado
	montar()
	
func montar():
	cash.text = "Cash:%.02f" % [ Comum.eu.cash ]
	for i in  v_box_container.get_children():
		if i.visible:
			i.queue_free()
	for i in Comum.eu.bag.itens:
		if i.qtd==0:
			continue
		var tmp=v_box_container.get_child(0).duplicate()
		var j=Comum.pegarItemById(i.id)
		if j == null:
			continue
		tmp.visible=true
		tmp.get_node("h/v/produto").text=j.descricao
		tmp.get_node("h/v/quantidde").text="Quantidade: %.02f" % [ i.qtd ]
		v_box_container.add_child(tmp)

func _on_button_pressed() -> void:
	queue_free()
