extends CanvasLayer

@onready var bt_principal: Panel = $v1/p0
@onready var v_box_container: VBoxContainer = $v1/v2/sc/v

var estrutura={}


func _ready() -> void:
	v_box_container.get_child(0).visible=false
	montar()


func montar():
	# dados do primeiro item a ser analisado
	bt_principal.get_node("t/t").texture=Comum.getImageById(estrutura.id)
	
	# limpa todos os atalhos anteriores, se houver, só segurança aqui
	for i in v_box_container.get_children():
		if i.visible: # se o objeto analisado estiver visivel, vamos apagar ele
			i.queue_free()
	var atalhos=["q","w","e","r","t"] # pegar desta forma pq, ao levar ao banco, ele organiza em ordem alfabetica os atalhos
	for keys in range(0,5):
		var i=atalhos[keys]
		var tmp=v_box_container.get_child(0).duplicate() # duplico o primeiro objeto da área (ele é o exemplo de como é)
		tmp.visible=true  # seto para visible=true, pois o primeiro sempre está invisível
		tmp.get_node("Label").text = i.to_upper() # só pra ficar butininho
		tmp.get_node("bt").connect("pressed",Callable(self,"_pressed").bind(i)) # aqui refaço o preesed que vai passar o botao que será trocado
		if not Comum.eu.atalhos.get(i).is_empty():
			tmp.get_node("t/t").texture=Comum.getImageById(Comum.eu.atalhos.get(i).id)
		v_box_container.add_child(tmp)


func _pressed(qual) -> void:
	# apagar as anteroires que forem iguais ao ataque passado em "qual"
	var atalhos=["q","w","e","r","t"] # pegar desta forma pq, ao levar ao banco, ele organiza em ordem alfabetica os atalhos
	for keys in range(0,5):
		var i=atalhos[keys]
		if Comum.eu.atalhos.get(i).is_empty(): # se este atalho estiver vazio, continue procurando
			continue
		if Comum.eu.atalhos.get(i).id == estrutura.id: # testa para saber se é o mesmo ID do que estou inserindo
			Comum.eu.atalhos.set(i,{}) # apago se existe duplicidade
	Comum.eu.atalhos.set(qual,estrutura) 	# atualizar o novo atalho
	Comum.player.atualizar_skills() # atualiza as skills do player na tela dele
	queue_free()

func _on_texture_button_pressed() -> void:
	queue_free() # não faz nada, apenas apaga
