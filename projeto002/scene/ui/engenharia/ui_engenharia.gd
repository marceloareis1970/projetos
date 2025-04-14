extends CanvasLayer
@onready var v_box_container: VBoxContainer = $NinePatchRect/VBoxContainer/c2/ScrollContainer/VBoxContainer
@onready var cash: Label = $NinePatchRect/VBoxContainer/c1/cash


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	montar()

func montar():
	cash.text = "Cash:%03d" % [ Comum.eu.cash ]
	var tporc=(Comum.eu.blindagem.atual * 1.0/Comum.eu.blindagem.maximo) * 100.0
	var custo=Comum.consertarNave()
	v_box_container.get_child(0).get_node("porcentagem").text="Blindagem nave:%% %0.02f" %[tporc]
	v_box_container.get_child(0).get_node("custo").text="Custo: %.02f" % [custo]
	if v_box_container.get_child(0).get_node("tb").is_connected("pressed",Callable(self,"consertarnave")):
		v_box_container.get_child(0).get_node("tb").disconnect("pressed",Callable(self,"consertarnave"))
	v_box_container.get_child(0).get_node("tb").connect("pressed",Callable(self,"consertarnave").bind(custo))

func _on_button_pressed() -> void:
	Comum.player_estacao=true
	queue_free()

func consertarnave(custo):
	if Comum.eu.cash < custo:
		Comum.mapa.setMsg("Você tá sem grana pra consertar")
		return
	Comum.eu.cash -= custo
	Comum.eu.blindagem.atual = Comum.eu.blindagem.maximo
	montar()
