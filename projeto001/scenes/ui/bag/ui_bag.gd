extends CanvasLayer

@onready var cash: Label = $n/c/c1/cash
@onready var v_box_container: GridContainer = $n/c/c2/v/H/s/g


func _ready() -> void:
	v_box_container.get_child(0).visible=false # esse é o modelo a ser duplicado
	montar()
	
func montar():
	cash.text = "Cash:%.02f" % [ Comum.eu.cash ] # coloca no titulo do inventário a quantidade de cash
	for i in  v_box_container.get_children(): # iremos apagar todos exceto o nosso modelo
		if i.visible:
			i.queue_free()
	for i in Comum.eu.bag.itens: # iteração com os itens da bag
		var tmp=v_box_container.get_child(0).duplicate() # fazemos uma duplicata no nosso modelo
		tmp.visible=true # colocaremos ele visível
		tmp.get_node("Label").text="" # reseta o texto dentro deste label 
		if i.qtd != 0: # se existir algum item deve ser {id:nnn,qtd:nnn}
			var j=Comum.getItemById(i.id) # pegaremos todos os detalhes do item desejado
			if j != null: # se encontrou, não existe erro, então iremos visulizar ele na tela para o usuário
				tmp.get_node("img").tooltip_txt=j.descricao # colocaremos no tooltip a descricao de nosso item
				tmp.get_node("img").texture=Comum.getImageById(i.id) # pegamos a imagem a partir da referencia
				tmp.get_node("Label").text="%02d" % [ i.qtd ] # descrevemos a qtd deste iten 
		v_box_container.add_child(tmp) # adicionaremos este slot a nossa bag

func _on_button_pressed() -> void:
	queue_free() # remove a tela 
