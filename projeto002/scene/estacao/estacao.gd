extends Node2D
@onready var ui_mapa: Node = $UI_mapa
@onready var ui_display: Node = $UI_display
@onready var ui_comercio: Node = $UI_comercio
@onready var ui_inventario: Node = $UI_inventario
@onready var ui_jornal: Node = $UI_jornal
@onready var label_estacao: Label = $UI/Label
@onready var v_box_container: VBoxContainer = $UI/ColorRect/ScrollContainer/VBoxContainer
@onready var color_rect: ColorRect = $UI/ColorRect


func _ready() -> void:
	Comum.mapa=self
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	color_rect.visible=false
	v_box_container.get_child(0).visible=false
	label_estacao.text = Comum.getEstacaoNome()

func _physics_process(delta: float) -> void:
	if color_rect.visible and v_box_container.get_child_count()==1:
		color_rect.visible=false

func ajuda():
	if ui_mapa.get_child_count() > 0:
		ui_mapa.get_child(0).queue_free()
	else:
		var temp=preload("res://scene/ui/ajuda/ui_ajuda.tscn").instantiate()
		ui_mapa.add_child(temp)

func mapa_normal():
	if ui_mapa.get_child_count() > 0:
		ui_mapa.get_child(0).queue_free()
	else:
		var temp=preload("res://scene/ui/mapa/mapa_m.tscn").instantiate()
		ui_mapa.add_child(temp)

func HiperDriver():
	if ui_mapa.get_child_count() > 0:
		ui_mapa.get_child(0).queue_free()
	else:
		var temp=preload("res://scene/ui/mapa/mapa_h.tscn").instantiate()
		ui_mapa.add_child(temp)

func displayTela():
	if ui_display.get_child_count() > 0:
		ui_display.get_child(0).queue_free()
	else:
		var temp=preload("res://scene/ui/display_tela/ui_display_tela.tscn").instantiate()
		ui_display.add_child(temp)

func getComercio():
	var temp=preload("res://scene/ui/comercio/ui_comercio.tscn").instantiate()
	ui_comercio.add_child(temp)

func getEngenharia():
	var temp=preload("res://scene/ui/engenharia/ui_engenharia.tscn").instantiate()
	ui_comercio.add_child(temp)

func displayInventario():
	if ui_inventario.get_child_count() > 0:
		ui_inventario.get_child(0).queue_free()
	else:
		var temp=preload("res://scene/ui/bag/ui_bag.tscn").instantiate()
		ui_inventario.add_child(temp)

func getComercioJornal():
	if ui_jornal.get_child_count() > 0:
		ui_jornal.get_child(0).queue_free()
	else:
		var temp=preload("res://scene/ui/jornal/ui_jornal.tscn").instantiate()
		ui_jornal.add_child(temp)	

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
