extends Node2D

@export var start:bool=true
@onready var color_rect: ColorRect = $UI/ColorRect

var estrutura=null
var speed:float = 100.0
var ativo:bool = false

func _ready() -> void:
	color_rect.visible=false
	position.x=554

func _physics_process(delta: float) -> void:
	color_rect.visible = ativo
	if ativo:
		if Input.is_action_just_pressed("F"):
			ativo = false
			Comum.player_estacao=true
			Comum.eu.estacao_espacial = estrutura.id
			Comum.eu.destino={}
			Comum.game.trocarParaEstacao()

func _process(delta: float) -> void:
	if not start and position.y <200:
		position.y += delta * speed
	else:
		if start:
			position.y += delta * speed
			if position.y > 1000:
				queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ativo=true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		ativo=false
		
