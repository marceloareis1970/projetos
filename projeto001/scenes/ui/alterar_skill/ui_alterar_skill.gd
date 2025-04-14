extends CanvasLayer
@onready var vskills: VBoxContainer = $n/s/v
@onready var control: Control = $Control
@onready var no_nine: NinePatchRect = $n


func _ready() -> void:
	Comum.eu.mover=false #evitar se mover
	vskills.get_child(0).visible=false # para ter certeza, seto o primeiro objeto para invisível para utilizar como exemplo
	montar() # executo a rotina montar. Coloco separada pq se precisar, executo ela e remonto a tela em questão de qualquer ponto


func montar():
	for i in vskills.get_children(): # Iteração em todos os objetos deste nó
		if i.visible: # testa para saber se este objeto está visível para o usuário
			i.queue_free() # destroi todos que estão invisíveis dentro deste NO
	for i in Comum.eu.repositorio_skill: # Iteração do repositório_skill, que tem todas suas skills
		var tmp=vskills.get_child(0).duplicate() # duplico o primeiro objeto deste nó que servirá com padrão/exemplo
		tmp.visible=true # coloco para visivel, pq o primeiro sempre será invisível
		tmp.get_node("bg/TextureRect").texture = Comum.getImageById( i.id ) # função de pegar a imagem passando o ID dela
		tmp.get_node("bt").connect("pressed",Callable(self,"setarVariavel").bind(i)) # reformulo a função pressed para passar um objeto
		vskills.add_child(tmp) # adiciono este objeto criado ao nó

func setarVariavel(oque):
	for i in control.get_children(): # este é o local onde chamaremos a outra tela
		i.queue_free() # se houver alguma tela dentro deste nó, iremos apagar
	var tmp=preload("res://scenes/ui/qualbotao/ui_qual_botao.tscn").instantiate() # UI para escolher o botão
	tmp.estrutura=oque # o botão escolhido foi este
	control.add_child(tmp)


func _on_button_pressed() -> void:
	Comum.eu.mover=true # volta a se movimentar
	queue_free() # destroi o objeto
