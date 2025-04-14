extends Node3D

@onready var panel: Panel = $CanvasLayer/Panel
@onready var animation_player: AnimationPlayer = $elevador/AnimationPlayer

var ativo:bool=false # definimos se tem algum player na região 3D
var destino:String="" # nesta variavel informamos qual mapa iremos 

func _ready() -> void:
	panel.visible=false # inlcializa invisivel na tela do player

func _physics_process(delta: float) -> void:
	panel.visible=ativo # seta o painel para visible ou invisible
	if ativo: # se ativo
		if Input.is_action_just_pressed("F"): #estamos pressionando a letra F
			ativo=false #seta para evitar duplo-click
			animation_player.play("start")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and  destino != "": # se o objeto detectado for um player
		ativo=true # setamos para true, e isso fará com que apareca a letra R na tela

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and destino != "": # se o objeto for um player, indica que ele está saindo da área
		ativo=false # então, vamos desativar a tela da Letra R

func ativar_elevador():
	Comum.mapa.carregaMapa(destino) # ativado pelo anima_player. envia direto para o destino
