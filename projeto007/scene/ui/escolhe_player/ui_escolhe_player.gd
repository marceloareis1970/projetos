extends CanvasLayer

@onready var no_nomes: VBoxContainer = $ColorRect/NinePatchRect/VBoxContainer/HBoxContainer/sc1/VBoxContainer
@onready var no_escolhido: TextureButton = $ColorRect/NinePatchRect/VBoxContainer/HBoxContainer/Panel/Panel/escolhido
@onready var no_escolhido_texto: RichTextLabel = $ColorRect/NinePatchRect/VBoxContainer/HBoxContainer/Panel/sc2/RichTextLabel


var escolhido:Dictionary={}

func _ready() -> void:
	get_tree().paused = true
	no_nomes.get_child(0).visible=false
	if not Comum.eu.is_empty():
		Database.update(Comum.eu.id,JSON.stringify(Comum.eu))
	montar()


func montar():
	for i in no_nomes.get_children():
		if i.visible:
			i.queue_free()
	
	for i in range(0,15):
		if not Comum.eu.is_empty():
			if Comum.eu.id == "player-%03d" % [i+1]:
				continue
		var resultado=Database.select("player-%03d" % [i+1])
		if typeof(resultado) != TYPE_DICTIONARY:
			continue
		var tmp=no_nomes.get_child(0).duplicate()
		tmp.visible=true
		tmp.get_node("bg/TextureRect").texture=load("res://assets/fotos/%s.png" % [resultado.avatar])
		tmp.get_node("bg/level").text="%02d" % [ resultado.nivel.atual ] 
		tmp.get_node("nome").text= resultado.nome
		tmp.get_node("classe").text= resultado.classe
		tmp.get_node("TextureButton").connect("pressed",Callable(self,"pressed").bind(resultado))
		no_nomes.add_child(tmp)

func _on_texture_button_pressed() -> void:
	if Comum.eu.is_empty():
		OS.alert("Precisa escolher um personagem antes","Atenção")
		return
	get_tree().paused = false
	queue_free()


func pressed(resultado) ->void:
	no_escolhido.disabled=false
	var sexo="Masculino"
	if resultado.sexo == "f":
		sexo="Feminino"
	var texto ="[font_size=10]"
	texto +="Nome:[color=red] %s[/color]\n" % [ resultado.nome]
	texto +="Sexo:[color=red] %s[/color]\n" % [ sexo ]
	texto +="Nivel:[color=red] %s[/color]\n" % [ int(resultado.nivel.atual)]
	texto +="Classe:[color=red] %s[/color]\n" % [ resultado.classe]
	texto +="HP:[color=red ] %s[/color]\n" % [ int(resultado.hp.maximo)]
	texto +="MP:[color=red] %s[/color]\n" % [ int(resultado.mp.maximo)]
	texto +="\n\n---Arma básica-----\n"
	texto +="Arma:[color=red] %s[/color]\n" % [ resultado.arma.tipo]
	texto +="Dano:[color=red] %s[/color]\n" % [ resultado.arma.damage]
	texto +="Cadência:[color=red] %s[/color]\n" % [ resultado.arma.tempo.maximo]
	texto +="\n\n---Atributos-----\n"
	texto +="Cura:[color=red] %s por segundo(s)[/color]\n" % [ resultado.atributos.cura]
	texto +="Defesa:[color=red] %s[/color]\n" % [ resultado.atributos.defesa]
	texto +="Mana:[color=red] %s por segundo(s)[/color]\n" % [ resultado.atributos.mana]
	texto +="Vel. Ataque:[color=red] %s[/color]\n" % [ resultado.atributos.velocidade_ataque]
	no_escolhido_texto.text=texto
	escolhido = resultado


func _on_escolhido_pressed() -> void:
	Comum.eu = escolhido
	Comum.mapa.carregarPlayer()
	Comum.player.global_position = Vector3(-62.781,0.1,-1.416)
	Database.update("player_atual",JSON.stringify(escolhido))
	get_tree().paused = false
	queue_free()
