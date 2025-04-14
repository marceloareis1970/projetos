extends Node2D

var ativo:bool=false
@onready var color_rect: ColorRect = $UI/ColorRect

func _ready() -> void:
	color_rect.visible=false

func _physics_process(delta: float) -> void:
	color_rect.visible = ativo
	if ativo:
		if Input.is_action_just_pressed("F"):
			ativo = false
			Comum.player_estacao=false
			Comum.mapa.getEngenharia()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ativo=true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		ativo=false
		
