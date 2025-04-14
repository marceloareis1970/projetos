extends CanvasLayer
@onready var rich_text_label: RichTextLabel = $NinePatchRect/VBoxContainer/c2/ScrollContainer/RichTextLabel

var comparar=[]

func _ready() -> void:
	montar()

func montar():
	rich_text_label.clear()
	rich_text_label.append_text("[color=red]Carta jornal preços no sistema[/color]\n")
	var texto="";
	for i in Dados.sistema_solar.get(Comum.eu.sistema_solar).planetas:
		if i.id == Comum.eu.estacao_espacial:
			comparar=i.produtos.duplicate(true)
			break
	var itemp=0
	for i in Dados.sistema_solar.get(Comum.eu.sistema_solar).planetas:
		if i.id == Comum.eu.estacao_espacial:
			continue
		texto =  "Estação:[color=blue]%s[/color]\n" %[ i.nome ]
		texto += "População:[color=blue]%s[/color]\n" %[ i.populacao ]
		texto += "[table=3][cell][center]Produto[/center][/cell]"
		texto += "[cell][center]Compra[/center][/cell]"
		texto += "[cell][center]Venda[/center][/cell]"
		#if itemp == 1:
			#print_debug(comparar,i.produtos)
		#itemp+=1
		for j in i.produtos:
			var imagem=compararPreco(j.id,j.preco_compra)
			var preco_compra="%s %s" % [j.preco_compra,imagem]
			imagem=compararPreco(j.id,j.preco_venda,false)
			var preco_venda="%s %s" % [j.preco_venda,imagem]
			var descricao = j.descricao
			if j.perigo == 1:
				descricao = "[color=red]*[/color]%s" %[ j.descricao ]
			texto += "[cell]%s[/cell][cell]%s[/cell][cell]%s[/cell]" % [ descricao,preco_compra,preco_venda]
		texto +="[/table]\n\n"
		rich_text_label.append_text(texto)

func _on_button_pressed() -> void:
	Comum.player_estacao=true
	queue_free()

func compararPreco(id,valor,compra=true):
	var img=""
	var v_comparar=""
	for i in comparar:
		if i.id != id:
			continue
		if compra:
			v_comparar = i.preco_compra
			if i.preco_compra < valor:
				img="[img=8x8]assets/img/arrow_down.png[/img]"
			elif i.preco_compra > valor:
				img="[img=8x8]assets/img/arrow_up.png[/img]"
			else:
				img="[img=8x8]assets/img/arrow_equal.png[/img]"
		else:
			v_comparar = i.preco_venda
			if i.preco_venda < valor:
				img="[img=8x8]assets/img/arrow_down.png[/img]"
			elif i.preco_venda > valor:
				img="[img=8x8]assets/img/arrow_up.png[/img]"
			else:
				img="[img=8x8]assets/img/arrow_equal.png[/img]"
	return img +" %s" % [v_comparar]
