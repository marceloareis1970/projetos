extends Node2D

@onready var inimigos: Node = $inimigos
@onready var tiros: Node = $tiros
@onready var texture_progress_bar: TextureProgressBar = $UI/NinePatchRect/TextureProgressBar
@onready var ui_mapa: Node = $UI_mapa
@onready var ui_display: Node = $UI_display
@onready var ui_inventario: Node = $UI_inventario
@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var estacao_indo: Node2D = $estacao/estacao
@onready var node_estacao: Node = $estacao
@onready var v_box_container: VBoxContainer = $UI/ColorRect/ScrollContainer/VBoxContainer
@onready var color_rect: ColorRect = $UI/ColorRect


var tempo:float=0.5
var tamanho= DisplayServer.screen_get_size()
var path=[]

func _ready() -> void:
	Comum.mapa=self
	color_rect.visible=false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	v_box_container.get_child(0).visible=false
	criarCaminho()

func _physics_process(delta: float) -> void:
	if color_rect.visible and v_box_container.get_child_count()==1:
		color_rect.visible=false
	informaDistancia()
	if Comum.mob:
		if Comum.wave <= 0:
			if inimigos.get_child_count() == 0:
				Comum.warp = true 
				Comum.mob = false
		else:
			tempo -= delta
			if tempo<0:
				Comum.wave -= 1
				tempo=randf_range(0.1,0.9)
				var tmp=preload("res://scene/enemy/enemy.tscn").instantiate()
				inimigos.add_child(tmp)
				tmp.movimento = ENEMY.MOVIMENTO.values().pick_random()
				tmp.position.x=randf_range(10,tamanho.x)
	else:
		if Comum.warp:
			if path.size()>0:
				if abs(Comum.origem - path[0]) <= 50:
					path.remove_at(0)
					Comum.wave = randi_range(2,4)
					Comum.warp = false
					Comum.mob = true
					
			Comum.origem += randf_range(1,2)
			if Comum.origem >= Comum.distancia:
				Comum.warp = false
				Comum.mob = false
				# estou na estação

func informaDistancia()->void:
	if Comum.eu.vivo:
		texture_progress_bar.value=Comum.origem

func addTiros(obj)->void:
	tiros.call_deferred("add_child",obj)

func criarCaminho(): # coloco os pontos de wave
	path.clear()
	Comum.origem=0  # variavel que conta a distancia até o seu destino
	Comum.distancia=randf_range(5000,7000)
	#Comum.distancia=400
	texture_progress_bar.value=0
	texture_progress_bar.max_value=Comum.distancia
	
	Comum.station=0 #indo para o espaco
	Comum.warp=true
	# criar todos os pontos entre a origem e o fim.. nos intervalos, coloca waves de mobs
	# define as waves, se atira, se intensa,
	#  comeca de 200 e vai até distancia - 200
	var dist=20
	while dist < Comum.distancia - 200:
		var valor=randi_range(400,900)
		if dist + valor >= Comum.distancia - 200:
			break
		dist += valor
		path.append(dist) # pontos que terão spawn de naves
	texture_progress_bar.connect("value_changed",Callable(self,"_on_texture_progress_bar_value_changed"))

func mapa_normal():
	if ui_mapa.get_child_count() > 0:
		ui_mapa.get_child(0).queue_free()
	else:
		var temp=preload("res://scene/ui/mapa/mapa_m.tscn").instantiate()
		ui_mapa.add_child(temp)

func displayTela():
	if ui_display.get_child_count() > 0:
		ui_display.get_child(0).queue_free()
	else:
		var temp=preload("res://scene/ui/display_tela/ui_display_tela.tscn").instantiate()
		ui_display.add_child(temp)

func displayInventario():
	if ui_inventario.get_child_count() > 0:
		ui_inventario.get_child(0).queue_free()
	else:
		var temp=preload("res://scene/ui/bag/ui_bag.tscn").instantiate()
		ui_inventario.add_child(temp)

func _on_texture_progress_bar_value_changed(value: float) -> void:
	if value == Comum.distancia and Comum.distancia > 0:
		var tmp=preload("res://scene/estacao/espaco_estacao.tscn").instantiate()
		tmp.estrutura=Comum.eu.destino
		tmp.start=false
		node_estacao.add_child(tmp)

func setMsg(msg:String):
	color_rect.visible=true
	var tmp=v_box_container.get_child(0).duplicate()
	tmp.visible=true
	tmp.text = msg
	v_box_container.add_child(tmp)
	v_box_container.move_child(tmp,1) #sempre inserir no primeiro elemento. O elemento ZERO é nosso molde
	tmp.get_node("Timer").connect("timeout",Callable(self,"unSetMsg").bind(tmp))
	tmp.get_node("Timer").start()
	
func unSetMsg(oque):
	
	oque.queue_free() # apagar esta msg da listagem de mensagens
