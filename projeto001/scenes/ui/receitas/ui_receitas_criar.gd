extends CanvasLayer

@onready var forja: HBoxContainer = $n/v/p/s/h
@onready var v_receitas: VBoxContainer = $n/v/p2/h/c1/a/v
@onready var h_scroll_qtd: HScrollBar = $n/v/p2/h/c2/c/p/h/h
@onready var v_itens_receitas: VBoxContainer = $n/v/p2/h/c2/s/v
@onready var bt_processar: TextureButton = $n/v/p2/h/c2/c/p/h/TextureButton
@onready var lb_qtd_forjar: Label = $n/v/p2/h/c2/c/p/h/c/Label
@onready var titulo: Label = $n/v/p2/h/c2/c2/titulo


var objeto_escolhido="" # id do objeto escolhido (receita) para ser criado

func _ready() -> void:
	Comum.eu.mover=false # impossibilita o player de se mover
	forja.get_child(0).visible=false # este será nosso modelo
	v_receitas.get_child(0).visible=false # este é o modelo da receita
	v_itens_receitas.get_child(0).visible=false # este é o modelo do item da receita
	montar() # rotina que monta a tela completa

func _physics_process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	Comum.eu.mover=true # volta a se movimentar
	queue_free() # destroi o objeto
	
func montar() -> void:
	bt_processar.disabled=true # desativa o botão de processar
	h_scroll_qtd.value=1 # reseta o qunatificador para 1
	objeto_escolhido="" # retornar o objeto escolhido para vazio
	for i in forja.get_children(): # iteração em todos os nós dentro deste nó
		if i.visible:
			i.queue_free() # remove ele da tela
	for i in Comum.npc_marquisa_construir.itens: # iteracao nos slots de forja
		var tmp=forja.get_child(0).duplicate()
		tmp.visible=true
		tmp.get_node("l").text=""
		forja.add_child(tmp) # adiciona o item a régua do slots
		if i != {}: # existe um slot da forja sendo feita
			var j=Comum.getItemById(i.id) # pegaremos todos os detalhes do item desejado
			if j != {} : # se existir, retorna algo
				tmp.get_node("bt").tooltip_text = j.descricao
			tmp.get_node("qtd").text="%02d" % [i.qtd]
			tmp.get_node("img").texture=Comum.getImageById(i.id)
			tmp.get_node("Timer").connect("timeout",Callable(self,"regressivo").bind(i,tmp)) # redireciona o item para a função, passado seu objeto
			tmp.get_node("Timer").start() # starta o timer deste item
	# receita
	for i in v_receitas.get_children():
		if i.visible:
			i.queue_free()
	for i in Comum.receitas:
		var tmp=v_receitas.get_child(0).duplicate()
		tmp.visible=true
		tmp.get_node("bg/img").texture = Comum.getImageById(i.id)
		var j=Comum.getItemById(i.id) # pegaremos todos os detalhes do item desejado
		tmp.get_node("h/v/lb1").text=j.titulo # colocar o título do item
		tmp.get_node("h/v/lb2").text=j.descricao # colocar o detalhe deste item
		tmp.get_node("h/bt").connect("pressed",Callable(self,"detalhes").bind(i.id)) # vamos definir o botão ao ser pressionado, passa também o ID desejado
		v_receitas.add_child(tmp)
	for i in v_itens_receitas.get_children():
		if i.visible:
			i.queue_free()
	
func detalhes(id):
	#neesta parte da rotina, vamos limpar o lado direito da tela e colocar todos os itens detalhados nela
	objeto_escolhido=id # salvo o objeto escolhido para ser forjado
	lb_qtd_forjar.text = "QTD:000" # reseto o texto de quantidade para o usuario
	bt_processar.disabled=true # desativa o botão de processar
	h_scroll_qtd.value=1 # reseta o qunatificador para 1
	var j=Comum.getItemById(id) # pegaremos todos os detalhes do item desejado
	titulo.text = "%s(%s)" % [ j.titulo, j.descricao]
	montar_detalhe() # montar a rotina. Desta forma pois poderemos verificar a quantidade de itens q desejamos fazer
	
func montar_detalhe():
	if objeto_escolhido == "": # bloqueia a passagem. somente se escolhermos uma receita
		return
	for i in v_itens_receitas.get_children():
		if i.visible:
			i.queue_free()
	var receita=Comum.getReceitaById(objeto_escolhido) # acha a receita selecionada e traz ela
	var botao_disabled=false # inicializa com o botão para fazer a receita habilitado
	if receita != null:
		for i in receita.itens: # iteração de todos os itens desta receita
			var tmp=v_itens_receitas.get_child(0).duplicate() # duplica o modelo do slot
			tmp.visible=true # torna o slot visível
			var item=Comum.getItemById(i.id) #pega todos os dados deste item na tabela
			var cor="white" # cor indica que temos o item
			if item == null: # na pesquisa, o item não foi encontrado
				item={"titulo":"??","descricao":"??"}# não sei qual item é este
				botao_disabled=true # o botão fica desabilitado, ou seja, não produz o item
				cor="red" # colocar a cor vermelha indicando que não foi atingido este item
			if not Comum.verificaItemQTDBag({"id":i.id,"qtd":int(i.qtd * h_scroll_qtd.value)}): # verificaremos se temos o item e a quantidade desejada na bag
				botao_disabled=true # o botão fica desabilitado, ou seja, não produz o item
				cor="red" # colocar a cor vermelha indicando que não foi atingido este item
			tmp.get_node("h/v/t").text="[color=red]%s[/color]\n%s\nQuantidade: [color=%s]%s[/color]" % [ 
				item.titulo,
				item.descricao,
				cor,
				int(i.qtd * h_scroll_qtd.value)
			] # descrevos o que é esta receita
			tmp.get_node("bg/img").texture=Comum.getImageById(i.id) # pegamos a imagem do item da receita
			v_itens_receitas.add_child(tmp) # adicionamos o slot, agora ele se torna visível
	lb_qtd_forjar.text = "QTD:%03d" % [int(receita.qtd * h_scroll_qtd.value)] # display a quantidade deste item que deseja forjar
	bt_processar.disabled=botao_disabled

func verificar_receita(): # funcao qe corre toda a receita para saber se existem os itens na bag
	pass

func regressivo(dados,obj):# esta função irá calcular o próximo segundo do item, se houver,..
	var retorno = Comum.getDiferencaEntreDuasDatas(Time.get_datetime_dict_from_system(),dados.tempo)
	if retorno.day == 0 and retorno.hour == 0 and retorno.minute == 0 and retorno.second == 0:
		obj.get_node("bt").mouse_default_cursor_shape = 2 # modifica o cursor para Hand
		obj.get_node("bt").connect("pressed",Callable(self,"pegar_item").bind(dados,obj))
		obj.get_node("l").text="%02d:%02d:%02d:%02d" % [ retorno.day,retorno.hour,retorno.minute,retorno.second ]
		return
	obj.get_node("Timer").start()
	obj.get_node("l").text="%02d:%02d:%02d:%02d" % [ retorno.day,retorno.hour,retorno.minute,retorno.second ]

func pegar_item(dados,obj):
	# faca uma iteracao nos fornos, verificando o pk com dados.pk. Se igual, remover da fornalha e add na bag
	for i in range(0,Comum.npc_marquisa_construir.itens.size()):
		if Comum.npc_marquisa_construir.itens[i] == {}: # se o item clicado não tem nada, continue para evitar erro
			continue
		if Comum.npc_marquisa_construir.itens[i].pk == dados.pk: # o PK serve para termos certeza de ser o item desejado
			if Comum.addBag({"id":dados.id,"qtd":dados.qtd}): # add o item a bag, se não conseguiu add, retorna false
				Comum.npc_marquisa_construir.itens[i]={} # apaga o objeto do slot de fabricação
			break # sai do for, para ir mais rápido
	montar() # refaz a tela toda, agora nao deve ter o item pronto

func _on_h_value_changed(value: float) -> void:
	h_scroll_qtd.get_node("craftar").text="%02d" % [ value ] # display na tela o valor correto
	montar_detalhe()

func _on_btminus_pressed() -> void:
	h_scroll_qtd.value -= 1 # ao alterar o scroll, automaticamente dispara o changed do scroll que atualiza o label para visualizar

func _on_tbmais_pressed() -> void:
	h_scroll_qtd.value += 1 # ao alterar o scroll, automaticamente dispara o changed do scroll que atualiza o label para visualizar

func _on_texture_button_pressed() -> void:
	# vamos agora tentar colocar na fornalha para ser feito
	var tem:bool=false # incializa a variavel para saber se teremos alguma fornalha disponivel (slot)
	for i in Comum.npc_marquisa_construir.itens:
		if i == {}: # existe um slot da forja disponivel
			tem=true
			break
	if not tem: # testa para saber se temos algum slot vazio, Se não tiver
		return # apenas retornamos
	var receita=Comum.getReceitaById(objeto_escolhido) # acha a receita selecionada e traz ela
	for i in receita.itens: # iteração de todos os itens desta receita
		var item=Comum.getItemById(i.id) #pega todos os dados deste item na tabela
		Comum.DelBag({"id":i.id,"qtd":int(i.qtd * h_scroll_qtd.value)})
	var qtd=int(receita.qtd * h_scroll_qtd.value)
	var tempo=int(receita.ciclos * h_scroll_qtd.value)
	var t1 = Time.get_unix_time_from_datetime_dict ( Time.get_datetime_dict_from_system() )
	var t2 = Time.get_datetime_string_from_unix_time( t1  + tempo )
	var t3 = Time.get_datetime_dict_from_datetime_string(t2,true)
	for i in range(0,Comum.npc_marquisa_construir.itens.size()):
		if Comum.npc_marquisa_construir.itens[i] == {}: # existe um slot da forja disponivel
			Comum.npc_marquisa_construir.itens[i]={"id":objeto_escolhido,"qtd":qtd,"tempo":t3,"pk":str(hash(Time.get_datetime_dict_from_system()))}
			break
	montar()
