extends CanvasLayer

@onready var no_tela: GridContainer = $Control/HBoxContainer



func _ready() -> void:
	get_tree().paused=true
	no_tela.get_child(0).visible=false
	montar()

func montar():
	for i in no_tela.get_children():
		if i.visible:
			i.queue_free()
	var skills=Database.select("todas_skills")
	(skills as Array).shuffle() 	#misturar
	for i in range(0,3):
		if i > skills.size():
			continue
		var dict_skill=Database.select(skills[i])
		var tmp=no_tela.get_child(0).duplicate()
		tmp.visible=true
		var texto=dict_skill.descricao+"\n[font_size=10]"
		texto = texto % [dict_skill.nome ]
		for k in dict_skill.melhorias:
			texto+="%s [color=blue]+%s[/color]\n" % [k.grupo,k.qtd]
		texto += "[/font_size]"
		tmp.get_node("p2/r").text=texto
		tmp.get_node("p1/TextureRect").texture = Comum.getImageById(dict_skill.id)
		tmp.get_node("p1/Label").text= dict_skill.nome
		tmp.get_node("p1").connect("pressed",Callable(self,"escolhido_item").bind(dict_skill))
		tmp.get_node("p1").connect("mouse_entered",Callable(self,"_on_v_box_container_mouse_entered").bind(tmp))
		tmp.get_node("p1").connect("mouse_exited",Callable(self,"_on_v_box_container_mouse_exited").bind(tmp))
		no_tela.add_child(tmp)

func _on_v_box_container_mouse_entered(tmp) -> void:
	tmp.scale=Vector2(1.02,1.02)

func _on_v_box_container_mouse_exited(tmp) -> void:
	tmp.scale=Vector2(1,1)

func escolhido_item(obj) -> void:
	Comum.escolheuCarta(obj)
	get_tree().paused = false
	queue_free()
