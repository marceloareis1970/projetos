extends CanvasLayer

@onready var vPlayers: VBoxContainer = $n/s/v


var tipo_plyers= [ 
		{
			"id":"arqueiro",
			"atributos":{"hp":{"atual":100,"maximo":100},"mp":{"atual":0,"maximo":0},"defesa":{"atual":23,"maximo":100}},
			"atalhos":{"q":{},"w":{"id":"s_spear-001","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5}},"e":{},"r":{},"t":{}},
			"cash":0,
			"bag":{"tamanho":10,"itens":[{"id":"m_hp-mob-001","qtd":10},{"id":"m_agua-001","qtd":20},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},]},
			"armas":[ {"id":"s_spear-001","type":"spear"},],
			"repositorio_skill":[{"id":"s_spear-001","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5},"type":"spear"},{"id":"s_spear-002","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5},"distancia":0.5,"type":"spear"},],
			"mover":true,"pode_atirar":true,
		}, 
		{
			"id":"maga",
			"atributos":{"hp":{"atual":20,"maximo":100},"mp":{"atual":0,"maximo":100},"defesa":{"atual":0,"maximo":50}},
			"atalhos":{"q":{},"w":{"id":"s_staff-001","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5}},"e":{},"r":{},"t":{}},
			"cash":0,
			"bag":{"tamanho":10,"itens":[{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},]},
			"armas":[ {"id":"s_staff-001","type":"staff"},],
			"repositorio_skill":[{"id":"s_staff-001","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5},"type":"staff"},{"id":"s_spear-001","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5},"distancia":0.5,"type":"spear"},],
			"mover":true,"pode_atirar":true,
		} , 
		{
			"id":"paladino",
			"atributos":{"hp":{"atual":20,"maximo":200},"mp":{"atual":0,"maximo":0},"defesa":{"atual":75,"maximo":100}},
			"atalhos":{"q":{},"w":{"id":"s_sword-001","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5}},"e":{},"r":{},"t":{}},
			"cash":0,
			"bag":{"tamanho":10,"itens":[{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},{"id":"","qtd":0},]},
			"armas":[ {"id":"s_sword-001","type":"sword"},],
			"repositorio_skill":[{"id":"s_spear-001","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5},"type":"spear"},{"id":"s_sword-001","damage":50,"speed":50,"deltatempo":{"atual":0,"maximo":0.5},"distancia":0.5,"type":"sword"},],
			"mover":true,"pode_atirar":true,
		}, 
]


func _ready() -> void:
	vPlayers.get_child(0).visible=false
	for i in tipo_plyers:
		var tmp=vPlayers.get_child(0).duplicate()
		tmp.visible=true
		tmp.get_node("t").texture=load("res://assets/players/%s.png" % [ i.id ])
		var texto="[color=white]nome[/color]:%s\n" % [ i.id ]
		texto += "[color=white]Atributos[/color]:\n"
		texto += "[color=red]hp[/color]:(%s/%s)\n" %[ i.atributos.hp.atual, i.atributos.hp.maximo ]
		texto += "[color=red]mp[/color]:(%s/%s)\n" %[ i.atributos.mp.atual, i.atributos.mp.maximo ]
		texto += "[color=red]defesa[/color]:(%s/%s)\n" %[ i.atributos.defesa.atual, i.atributos.defesa.maximo ]
		tmp.get_node("l").text=texto
		tmp.get_node("bt").connect("pressed",Callable(self,"pressed").bind(i))
		vPlayers.add_child(tmp)

func pressed(i:Dictionary):
	Database.atualizar("eu",JSON.stringify(i)) # salva sua escolha
	Database.atualizar("npc_marquisa_construir",JSON.stringify({"qtd":3,"itens":[{},{},{},]})) # 
	get_tree().change_scene_to_file("res://scenes/mapa/mapa.tscn")

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/tela_inicial/ui_start.tscn") # quando pressionamos o botão, vamos executar esta rotina
